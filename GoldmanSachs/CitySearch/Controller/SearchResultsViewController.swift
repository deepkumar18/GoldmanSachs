//
//  SearchResultsViewController.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//


import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    /// Rest manager caller
    private let rest = RestManager()
    
    /// Weather Response Model
    private var weatherAPIResponseModel: WeatherAPIResponseModel?
    
    /// Previous Saved City Info Data
    private var savedInfoData: [CityInfoCD]?
    
    /// Activity Indicator
    private lazy var activityIndicator: ActivityIndicator = Utils.getActivityIndicator(self.navigationController?.view ?? self.view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupSearchBar()
        self.initVariables()
        self.registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getCityInfo()
    }
}

extension SearchResultViewController {
    
    /**
    To setup a table view
    */
    private func setupTableView() {
        self.resultTableView.tableFooterView = UIView()
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
    }
    
    /**
    To register cells
    */
    private func registerCells()  {
        SearchedCityListTableViewCell.registerNibForTable(resultTableView)
    }
    
    /**
    To initltize variables
    */
    private func initVariables() {
        self.title = "Weather Information"
        self.citySearchBar.placeholder = "Search by city name!"
    }
    
    /**
    To Setup Search bar
    */
    private func setupSearchBar() {
        self.citySearchBar.delegate = self
        self.citySearchBar.becomeFirstResponder()
    }
}


//MARK:- TableView Delegate Methods
extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedInfoData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.savedInfoData?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchedCityListTableViewCell.ReuseIdentifier) as! SearchedCityListTableViewCell
        if let cityModel = model {
            cell.setUpcell(cityInfo: cityModel) { cityInfoData in
                let cityInfoModel = CityInfoModel(cityName: cityInfoData?.city_name, cityTemp: cityInfoData?.city_temp, cityHumidity: cityInfoData?.city_humidity, citySealevel: cityInfoData?.city_sealevel, isFavorite: cityInfoData?.favorite ?? false)
                GenericsObjectMapper.saveTargets(targetsModelArray: cityInfoModel, managedObjectContext: DatabaseManager.sharedInstance.childContext) { isSaved, savedData in
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                    section: Int) -> String? {
        return "Previous Searches"
    }
}

//MARK:- SearchBar Delegate Methods
extension SearchResultViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            self.getCityDetails(searchString: searchedText)
        }
    }
}

//MARK:- SearchBar Delegate Methods
extension SearchResultViewController {
    
    func getCityDetails(searchString: String) {
        self.activityIndicator.startAnimating()
        guard Reachability.isConnectedToNetwork() else {
            self.activityIndicator.stopAnimating()
            showNoInternetConnectionAlert()
            return
        }
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(searchString)&appid=d13e327862b35cb7739e985fcde1f070") else { return }
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                let decoder = JSONDecoder()
                guard let cityWeatherInfo = try? decoder.decode(WeatherAPIResponseModel.self, from: data) else { return }
                self.weatherAPIResponseModel = cityWeatherInfo
                self.createDataModel(cityResponse: cityWeatherInfo)
            }else if response.httpStatusCode == 404{
                self.showAlertWith(title: "Oops!", message: "Please search a valid city name.") {
                }
            }else {
                self.showAlertWith(title: "Oops!", message: "Something went wrong!.") {
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK:- DataModel
extension SearchResultViewController {
    func createDataModel(cityResponse: WeatherAPIResponseModel) {
        DispatchQueue.main.async {
            let cityInfoData = CityInformationData(humidty: String(cityResponse.list.first?.main.humidity ?? 0), temp: String(cityResponse.list.first?.main.temp ?? 0.0), seaLevel: String(cityResponse.list.first?.main.seaLevel ?? 0), cityName: self.citySearchBar.text ?? "")
            let cityInfoModel = CityInfoModel(cityName: cityInfoData.cityName, cityTemp: cityInfoData.temp, cityHumidity: cityInfoData.humidty, citySealevel: cityInfoData.seaLevel, isFavorite: false)
            GenericsObjectMapper.saveTargets(targetsModelArray: cityInfoModel, managedObjectContext: DatabaseManager.sharedInstance.childContext) { isSaved, savedData in
                self.navigateToCityView(cityResponse: cityInfoData)
            }
        }
    }
    
    func navigateToCityView(cityResponse: CityInformationData) {
        if let cityInfoViewController = SearchResultViewController.loadViewController(AppConstants.CitySearchStoryboard.kStoryboardName, vcIdentifier: AppConstants.CitySearchStoryboard.kCityInformationViewController) as? CityInformationViewController {
            cityInfoViewController.cityInfo = cityResponse
            self.navigationController?.pushViewController(cityInfoViewController, animated: true)
        }
        
    }
    
    func getCityInfo() {
        guard let allJuniors = CityInfoCD.all(mangedObjectContext: DatabaseManager.sharedInstance.mainContext) as? [CityInfoCD] else {
            self.showAlert(title: "Oops!", message: "We are not able to get your data", cancelButtonTitle: "Ok")
            return
        }
        self.savedInfoData = allJuniors
        self.resultTableView.reloadData()
    }
}
