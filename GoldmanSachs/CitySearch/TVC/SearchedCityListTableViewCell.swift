//
//  SearchedCityListTableViewCell.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 28/06/21.
//

import UIKit

class SearchedCityListTableViewCell: UITableViewCell,ReusableProtocol {
    
    /// City Name Label
    @IBOutlet weak var cityName: UILabel!
    
    /// City Temp Label
    @IBOutlet weak var cityTempLabel: UILabel!
    
    /// City Humidity Label
    @IBOutlet weak var cityHumidityLabel: UILabel!
    
    /// City Sea Level Label
    @IBOutlet weak var citySeaLevel: UILabel!
    
    /// Favorite Button Outlet
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    /// CallBack
    fileprivate var didSelectFavorite: ((CityInfoCD?) ->())?
    
    /// City Info
    var cityInfo: CityInfoCD?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    ///  It will  be used to setup cell....
    ///
    /// - cityInfo:  City information
    /// - didSelectFavorite: Call bak
    func setUpcell(cityInfo: CityInfoCD?, didSelectFavorite: ((CityInfoCD?) ->())? = nil) {
        guard let cityInformation = cityInfo else {
            return
        }
        self.didSelectFavorite = didSelectFavorite
        self.cityName.text =  "CityName:  " + (cityInformation.city_name ?? "")
        self.cityTempLabel.text = "CityTemp:  " + (cityInformation.city_temp ?? "")
        self.cityHumidityLabel.text = "CityHumidity:  " + (cityInformation.city_humidity ?? "")
        self.citySeaLevel.text = "CitySeaLevel:  " + (cityInformation.city_sealevel ?? "")
        if cityInformation.favorite == true {
            favoriteButtonOutlet.setImage(UIImage(named: "favoriteLoveIcon"), for: .normal)
        }else {
            favoriteButtonOutlet.setImage(UIImage(named: "favoriteIcon"), for: .normal)
        }
        self.cityInfo = cityInformation
    }
    
    @IBAction func didSelectFavoriteButton(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "favoriteIcon") {
            self.cityInfo?.favorite = true
            favoriteButtonOutlet.setImage(UIImage(named: "favoriteLoveIcon"), for: .normal)
        }else  {
            self.cityInfo?.favorite = false
            favoriteButtonOutlet.setImage(UIImage(named: "favoriteIcon"), for: .normal)
        }
        self.didSelectFavorite?(self.cityInfo)
    }
}
