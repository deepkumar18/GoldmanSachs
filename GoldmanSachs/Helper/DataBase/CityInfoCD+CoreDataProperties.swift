//
//  CityInfoCD+CoreDataProperties.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 28/06/21.
//
//

import Foundation
import CoreData


extension CityInfoCD {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityInfoCD> {
        return NSFetchRequest<CityInfoCD>(entityName: "CityInfoCD")
    }
    
    @NSManaged public var city_name: String?
    @NSManaged public var city_humidity: String?
    @NSManaged public var city_sealevel: String?
    @NSManaged public var city_temp: String?
    @NSManaged public var favorite: Bool
    
}

extension CityInfoCD : Identifiable {}


