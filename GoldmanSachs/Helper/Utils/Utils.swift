//
//  Utils.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//

import Foundation
import UIKit

class Utils: NSObject {
    static func getActivityIndicator(_ inView: UIView? = nil) -> ActivityIndicator {
        guard let _ = inView else {
            let window = UIApplication.shared.keyWindow!
            return ActivityIndicator.setSubviewOf(superViewT: window)
        }
        let view: UIView
        if let superviewT = inView?.superview, inView is UITableView {
            view = superviewT
        } else {
            view = inView!
        }
        return ActivityIndicator.setSubviewOf(superViewT: view)
    }
}
