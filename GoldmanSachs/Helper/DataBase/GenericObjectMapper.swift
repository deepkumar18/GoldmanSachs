//
//  GenericObjectMapper.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//

import Foundation
import CoreData


class GenericsObjectMapper {
    ///  It will  be used to Save The City Model
    ///
    /// - targetsModelArray:  City Information Model
    /// - managedObjectContext: NsmanagedObjectContext
    /// - result:  Whether It Is Saved
    /// - mappedObject: City Info
    class func saveTargets(targetsModelArray: CityInfoModel, managedObjectContext moc: NSManagedObjectContext, completion:((_ result: Bool, _ mappedObject: CityInfoCD?) -> Void)? = nil) {
        var mappedObject: CityInfoCD?
        moc.performAndWait {
            if let targetObj = CityInfoCD.getTargetWithModel(targetsModelArray, managedObjectContext: moc, targetObj: nil) {
                mappedObject = targetObj
            }
        }
        if let mappedObjectUnwrapped = mappedObject {
            DatabaseManager.sharedInstance.saveContextSynchronously(moc) { (result) -> Void in
                completion?(result, mappedObjectUnwrapped)
            }
        } else {
            completion?(false, nil)
        }
    }
}
