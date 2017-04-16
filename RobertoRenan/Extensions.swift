//
//  Extensions.swift
//  RobertoRenan
//
//  Created by Roberto Veiga Junior on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import Foundation

extension Double {
    func addIof(iof: Double) -> Double {
        let total = self + (self*iof/100)
        return total
    }
    
    func addTax(tax: Double) -> Double {
        let total = self + (self*tax/100)
        return total
    }
}
