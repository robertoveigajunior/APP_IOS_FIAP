//
//  Extensions.swift
//  RobertoRenan
//
//  Created by Roberto Veiga Junior on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit

enum CurrencyType: String {
    case dolar = "en_US"
    case real = "pt_BR"
}

extension UIImageView {
    func setBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}

extension UIColor {
    public class var primary: UIColor
    {
        return #colorLiteral(red: 0.0117072789, green: 0.6241955757, blue: 0.9112529159, alpha: 1)
    }
}

extension Double {
    private func currencyFormatter(value: Double, identifier: CurrencyType?) -> String {
        let formatter = NumberFormatter()
        if identifier != nil {
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: identifier!.rawValue)
        }else {
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
        }
        return formatter.string(from: NSNumber(floatLiteral: value))!
    }
    
    var addIof: Double {
        let iof = UserDefaults.standard.double(forKey: SettingsType.iof.rawValue)
        let total = self + (self*iof/100)
        return total
    }
    
    func addTax(tax: Double) -> Double {
        let total = self + (self*tax/100)
        return total
    }
    
    var currency: String {
        return currencyFormatter(value: self, identifier: nil)
    }
    
    var currencyDolar: String {
        return currencyFormatter(value: self, identifier: .dolar)
    }
    
    var currencyReal: String {
        return currencyFormatter(value: self, identifier: .real)
        
    }
}
