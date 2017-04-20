//
//  TotalViewController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 26/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var tfDolarTotal: UILabel!
    @IBOutlet weak var tfRealTotal: UILabel!
    
    var dataSource = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try dataSource = context.fetch(fetchRequest)
            setLabels()
        } catch {
            print("erro")
        }
    }
    
    func dolarTotal() -> Double {
        let total = dataSource.map({$0.price}).reduce(0,+)
        return total
    }
    
    func realTotal() -> Double {
        let dolar = UserDefaults.standard.double(forKey: SettingsType.dolar.rawValue)
        let total = (dataSource.map({$0.price}).reduce(0,+))*dolar
        return total
    }
    
    func setLabels() {
        tfDolarTotal.text = dolarTotal().currencyDolar
        tfRealTotal.text = realTotal().currencyReal
    }
}
