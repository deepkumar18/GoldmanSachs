//
//  CustomExtension.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//

import Foundation
import UIKit

public extension UIViewController {
    
    func showAlertWith(title: String = NSLocalizedString("Error", comment: "Error"), message: String, completion:(() -> Void)? = nil) {
        self.showAlertWith(title: title, message: message, style: UIAlertController.Style.alert, actions: UIAlertAction(title: "Ok", style: .default, handler: { alert in
            completion?()
        }))
    }
    
    func showAlertWith(title: String, message: String?, style: UIAlertController.Style,  actions: UIAlertAction... ) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)
        for i in actions {
            alert.addAction(i)
        }
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func loadViewController(_ storyboardName: String, vcIdentifier: String? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let vcIdentifier = vcIdentifier {
            return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
        } else {
            return storyboard.instantiateInitialViewController()
        }
    } 
}


extension UIViewController {
    
    func showAlert(title: String?, message: String?, cancelButtonTitle: String, otherButtonTitle: String? = nil, cancelCallBack:(() -> ())? = nil, actionCallBack: (() -> ())? = nil,style: UIAlertAction.Style? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: style ?? UIAlertAction.Style.cancel, handler: { (_) in
            cancelCallBack?()
        }))
        if let otherButtonTitleUW = otherButtonTitle {
            alert.addAction(UIAlertAction(title: otherButtonTitleUW, style: .default, handler: { (_) in
                actionCallBack?()
            }))
        }
        self.presentController(alert)
    }
    
    func showNoInternetConnectionAlert(cancelCallBack:(() -> ())? = nil) {
        showAlert(title: "Oops!", message: "Your internet connection appears to be offline", cancelButtonTitle: "Ok", cancelCallBack: cancelCallBack)
    }
    
    func presentController(_ controller: UIViewController?, animated: Bool = true, completion:(() -> Void)? = nil) {
        if let controller = controller {
            DispatchQueue.main.async(execute: { () -> Void in
                if controller.modalPresentationStyle != .overCurrentContext {
                    controller.modalPresentationStyle = .fullScreen
                }
                self.present(controller, animated: animated, completion: completion)
            })
        }
    }
}

extension UIView {
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
}
