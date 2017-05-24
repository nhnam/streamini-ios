//
//  UINavigationBarExtension.swift
//  Streamini
//
//  Created by Vasily Evreinov on 29/09/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import Foundation

extension UINavigationBar {
    
    class func setCustomAppereance() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "nav-background"), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "nav-border")
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    class func resetCustomAppereance() {
        UINavigationBar.appearance().tintColor = nil
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = nil
        UINavigationBar.appearance().titleTextAttributes = nil
    }
}
