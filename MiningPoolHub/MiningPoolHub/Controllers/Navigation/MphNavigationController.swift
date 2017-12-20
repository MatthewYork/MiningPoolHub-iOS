//
//  MphNavigationController.swift
//  MiningPoolHub
//
//  Created by Matthew York on 12/19/17.
//

import UIKit

open class MphNavigationController: UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setTheme()
    }
    
    func setTheme() {
        self.navigationBar.isOpaque = true;
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.backgroundColor = UIColor.black
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        //self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}
