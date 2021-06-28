//
//  CityInformationViewController.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//

import UIKit

struct CityInformationData {
    var humidty: String
    var temp: String
    var seaLevel: String
    var cityName: String
}

class CityInformationViewController: UIViewController {
    
    /// Tempearture Label
    @IBOutlet weak var tempLabel: UILabel!
    
    /// Humidity Label
    @IBOutlet weak var humidityLabel: UILabel!
    
    /// Sea Level Label
    @IBOutlet weak var seaLevelLabel: UILabel!
    
    /// City Information
    var cityInfo: CityInformationData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpVariables()
    }
    
    func setUpVariables() {
        self.title = cityInfo?.cityName ?? ""
        self.tempLabel.text = "Temp: " + (cityInfo?.temp ?? "")
        self.humidityLabel.text = "Humidity: " + (cityInfo?.humidty ?? "")
        self.seaLevelLabel.text = "Sealevel: " + (cityInfo?.seaLevel ?? "")
    }
}
