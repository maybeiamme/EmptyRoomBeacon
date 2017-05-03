//
//  BeaconContentViewController.swift
//  Test360
//
//  Created by Kenneth Poon on 26/4/17.
//  Copyright © 2017 Kenneth Poon. All rights reserved.
//

import Foundation
import UIKit

class BeaconContentViewController: UIViewController {
    
    var webView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        self.fitView(subView: webView, superView: self.view)
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = (bundle.resourceURL as NSURL?)?.appendingPathComponent("EmptyRoomBeacon.bundle") else {
            return
        }
        
        guard let resourcebundle = Bundle(url: url) else {
            return
        }

        let scale = UIScreen.main.scale
        let backButton = UIButton(frame: CGRect(x:20, y: 30, width: 30, height: 30))
        if scale == 1.0 {
            let image = UIImage(named: "delete-512.png", in: resourcebundle, compatibleWith: nil)
            backButton.setImage(image, for: .normal)
        } else if scale == 2.0 {
            let image = UIImage(named: "delete-512@2x.png", in: resourcebundle, compatibleWith: nil)
            backButton.setImage(image, for: .normal)
        } else if scale == 3.0 {
            let image = UIImage(named: "delete-512@3x.png", in: resourcebundle, compatibleWith: nil)
            backButton.setImage(image, for: .normal)
        }
        backButton.addTarget(self, action: #selector(closeContent), for: .touchUpInside)
        self.view.addSubview(backButton)
        
    }
    
    
    
    func closeContent(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func fitView(subView: UIView, superView: UIView?, left:Int = 0,right:Int  = 0,top:Int  = 0,bottom:Int = 0){
        subView.translatesAutoresizingMaskIntoConstraints = false
        superView?.addConstraint(NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: CGFloat(top)))
        superView?.addConstraint(NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1.0, constant: CGFloat(left)))
        superView?.addConstraint(NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: CGFloat(bottom)))
        superView?.addConstraint(NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1.0, constant: CGFloat(right)))
    }
}

