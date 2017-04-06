//
//  CustomNavigationController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 25/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController , UIAlertViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
               
        let primaryColor = #colorLiteral(red: 0.0117072789, green: 0.6241955757, blue: 0.9112529159, alpha: 1)
        let itemColor = UIColor.white
        
        var dict = Dictionary<String, UIColor>()
        dict.updateValue(itemColor,
                         forKey: NSForegroundColorAttributeName)
        dict.updateValue(itemColor,
                         forKey: NSBackgroundColorAttributeName)
        self.navigationBar.titleTextAttributes = dict
        
        self.navigationBar.barTintColor = primaryColor
        self.navigationBar.tintColor = itemColor
        self.navigationBar.isTranslucent = false
        
        UIToolbar.appearance().tintColor = itemColor
        //UITabBar.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
