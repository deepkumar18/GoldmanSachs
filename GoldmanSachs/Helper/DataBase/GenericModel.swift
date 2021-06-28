//
//  GenericModel.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//

import Foundation

// MARK:- CityInformationModel
struct CityInfoModel: Codable {
    var cityName: String?
    var cityTemp: String?
    var cityHumidity: String?
    var citySealevel: String?
    var isFavorite: Bool
}
