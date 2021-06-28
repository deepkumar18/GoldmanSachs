//
//  CityInfoCD+CoreDataClass.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 28/06/21.
//
//

import Foundation
import CoreData

@objc(CityInfoCD)
public class CityInfoCD: NSManagedObject {
}

// MARK:- CityInformation
extension CityInfoCD: ManagedObjectProtocol {
    
    static var managedEntityName: String { return "CityInfoCD" }
    
    class func getTargetWithModel(_ targetModel: CityInfoModel, managedObjectContext moc: NSManagedObjectContext, targetObj: CityInfoCD?) -> CityInfoCD? {
        guard let target  = targetObj ?? CityInfoCD.getUniqueTarget(withID: targetModel.cityName, inMangedObjectContext: moc) else {
            return nil
        }
        target.city_name = targetModel.cityName
        target.city_humidity = targetModel.cityHumidity
        target.city_temp = targetModel.cityTemp
        target.city_sealevel = targetModel.citySealevel
        target.favorite =  targetModel.isFavorite
        return target
    }
    
    class func getUniqueTarget(withID: String?, inMangedObjectContext moc: NSManagedObjectContext) -> CityInfoCD? {
        guard let targetID = withID else {
            return nil
        }
        let target = CityInfoCD.getUniqueObject(NSPredicate(format:  "city_name ==[c] %@", targetID), inMangedObjectContext: moc) as? CityInfoCD
        return target
    }
}
