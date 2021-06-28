//
//  AcitivityIndicator.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 27/06/21.
//

import UIKit
import Lottie

class ActivityIndicator: UIView {
    
    var loaderColor: UIColor! = UIColor(red: 0.0/255.0, green: 130.0/255.0, blue: 195.0/255.0, alpha: 1)
    var backColor: UIColor! = UIColor(red: 225.0/255, green: 225.0/255, blue: 225.0/255, alpha: 0.1)
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var hideWhenStopped: Bool = true
    var startAnimatingOnLoad: Bool  = false
    var isAnimating: Bool = false
    var isNibLoaded: Bool = false
    private weak var mySuperView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isNibLoaded = true
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static func setSubviewOf(superViewT: UIView) -> ActivityIndicator {
        let activityIndicator = ActivityIndicator.init(frame: CGRect(x: 0, y: 0, width: superViewT.bounds.width, height: superViewT.bounds.height))
        superViewT.addSubview(activityIndicator)
        superViewT.bringSubviewToFront(activityIndicator)
        activityIndicator.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true
        activityIndicator.mySuperView = superViewT
        return activityIndicator
    }
    
    func setupFor(superViewT: UIView) {
        self.frame = CGRect(x: 0, y: 0, width: superViewT.bounds.width, height: superViewT.bounds.height)
        superViewT.addSubview(self)
        superViewT.bringSubviewToFront(self)
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
        self.mySuperView = superViewT
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        }
        self.setBlurView()
        self.addSubview(activityIndicator)
        activityIndicator.center = self.center
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: activityIndicator ?? UIView(), attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0), NSLayoutConstraint(item: activityIndicator ?? UIView(), attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0)])
        activityIndicator.color = loaderColor
        activityIndicator.hidesWhenStopped = true
        self.setupActivityIndicatorShadow()
        if startAnimatingOnLoad {
            self.startAnimating()
        } else if self.hideWhenStopped && !isAnimating {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
    }
    
    func setBlurView() {
        // Init a UIVisualEffectView which going to do the blur for us
        let blurView = UIVisualEffectView()
        // Make its frame equal the main view frame so that every pixel is under blurred
        blurView.frame = UIScreen.main.bounds
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .extraLight)
        // Now add the blur view to the main view
        blurView.alpha = 0.5
        self.addSubview(blurView)
    }
    
    func setupActivityIndicatorShadow() {
        activityIndicator.shadowOffset = CGSize(width: 1, height: 1)
        activityIndicator.shadowRadius = 2
        activityIndicator.shadowOpacity = 0.5
    }
    
    // MARK: Draw Rect
    override func draw(_ rect: CGRect) {
        if isAnimating {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
    
    func restartAnimationOnForeground() {
        if isAnimating {
            self.layer.removeAllAnimations()
            self.startAnimating()
        } else {
            self.stopAnimating()
        }
    }
    
    //MARK: Animation Methods
    func startAnimating() {
        DispatchQueue.main.async { [weak self] in
            if self?.superview == nil && self?.mySuperView != nil {
                self?.setupFor(superViewT: self!.mySuperView!)
            }
            if let view  = self?.superview, view.subviews.last != self {
                view.bringSubviewToFront(self!)
            }
            self?.isHidden = false
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
        self.isAnimating = true
    }
    
    func stopAnimating() {
        DispatchQueue.main.async { [weak self] in
            if self?.isAnimating == true {
                self?.activityIndicator.stopAnimating()
            }
            if self?.hideWhenStopped == true {
                self?.isHidden = true
            }
            if self?.isNibLoaded != true {
                self?.removeFromSuperview()
            }
        }
        self.isAnimating = false
    }
}
