//
//  UIViewController+CoreData.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 31/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
