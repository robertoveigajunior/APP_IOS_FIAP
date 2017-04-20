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
               
        let primaryColor = UIColor.primary
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
        
        UIToolbar.appearance().tintColor = primaryColor
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
