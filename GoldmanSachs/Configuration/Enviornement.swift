//
//  Enviornement.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 28/06/21.
//

import Foundation

struct Environment {
    // MARK: - Keys
    enum Keys: String {
        case environmentName = "UNIVERSE"
        case appID = "IRON_MAN"
        case baseURL = "FURY"
        
        func  getData() -> String {
            guard let data = Environment.infoDictionary[self.rawValue] as? String else {
                fatalError(self.rawValue + " not set in plist for this environment")
            }
            return data
        }
    }
    
    // MARK: - Plist
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
}
