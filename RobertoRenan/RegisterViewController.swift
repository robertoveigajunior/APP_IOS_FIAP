//
//  RegisterViewController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 25/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var tfNameProduct: UITextField!
    @IBOutlet weak var imgProduct: UIButton!
    @IBOutlet weak var tfPurchaseState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    
    var stateSelected: State?
    var imageSelected: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func withCreditCard(_ sender: UISwitch) {
        
    }
    
    @IBAction func selectState(_ sender: UIButton) {
        
    }
    
    @IBAction func saveProduct(_ sender: UIBarButtonItem) {
        save()
    }
}

//MARK: - Methods

extension RegisterViewController {
    
    func save() {
        let product = Product(context: context)
        
        if let name = tfNameProduct.text?.validator(context: self) {
            product.name = name
        }else if let image = imageSelected {
            product.image = image
        }else if let purchaseState = stateSelected {
            product.states = purchaseState
        }else if let price = tfPrice.text?.validator(context: self) {
            product.price = Double(price)!
        }
        
    }
}

extension String {
    func validator(context: UIViewController) -> String? {
        guard !self.isEmpty else {
            let alert = UIAlertController(title: "Atenção", message: "Preencha todos os campos", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alert.addAction(okAction)
            context.present(alert, animated: true, completion: nil)
            return nil
        }
        return self
    }
}














