//
//  RegisterViewController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 25/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var tfNameProduct: UITextField!
    @IBOutlet weak var tfPurchaseState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var swIOF: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickerView: UIPickerView!
    var stateSelected: State?
    var imageSelected: UIImage?
    var dataSource: [State]!
    var hasCreditCard = false
    var smallImage = UIImage()
    var product: Product?
    var toolbar = UIToolbar()
    
    var iof: Double!
    var tax: Double!
    var viewPosition: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolBar()
        pickerView = UIPickerView()
        tfPurchaseState.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        addToolBar()
        tfPurchaseState.inputView = pickerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isEdit()
        loadStates()
    }

    @IBAction func withCreditCard(_ sender: UISwitch) {
        hasCreditCard = sender.isOn
    }
    
    @IBAction func saveProduct(_ sender: UIBarButtonItem) {
        saveProduct()
    }
    
    @IBAction func getImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar imagem",
                                      message: "Como você deseja escolher a imagem?",
                                      preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) {
                (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) {
            (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - TextField
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        upView(textField: textField)
    }
}

//MARK: - Methods
extension RegisterViewController {
    func upView(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:80), animated: true)
    }
    
    func isEdit() {
        if product != nil {
            tfNameProduct.text = product!.name
            imgProduct.image = product!.image as! UIImage!
            tfPurchaseState.text = product!.state?.name
            tfPrice.text = product!.price.currency
            swIOF.isOn = product!.iof
        }
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setToolBar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btEdit = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancel))
        
        toolbar.items = [space, btEdit]
        tfNameProduct.inputAccessoryView = toolbar
        tfPrice.inputAccessoryView = toolbar
    }
    func cancel() {
        tfPurchaseState.resignFirstResponder()
        tfNameProduct.resignFirstResponder()
        tfPrice.resignFirstResponder()
    }
    
    func done() {
        if dataSource.count > 0 {
        tfPurchaseState.text = dataSource[pickerView.selectedRow(inComponent: 0)].name
        stateSelected = dataSource[pickerView.selectedRow(inComponent: 0)] as State
        }
        cancel()
    }
    
    func addPickerView() {
        tfPurchaseState.inputView = pickerView
    }
    
    func addToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))

        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))


        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        toolBar.items = [btCancel,space,btDone]
        tfPurchaseState.inputAccessoryView = toolBar
    }
    
    func saveProduct() {
        if validator() {
            do {
                try context.save()
                navigationController!.popViewController(animated: true)
            } catch {
                print("Algo errado ao salvar Produto")
            }
        }
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try dataSource = context.fetch(fetchRequest)
            print(dataSource.count)
            pickerView.reloadAllComponents()
        } catch {
            print("erro")
        }
    }
    
    func buildProduct() {
        if product == nil {
            product = Product(context: context)
        }
        product!.name = tfNameProduct.text
        if let image = imageSelected {
            product!.image = image
        }
        if let purchaseState = stateSelected {
            product!.state = purchaseState
        }
        if tfPrice.text != "" {
            product!.price = Double(tfPrice.text!.replacingOccurrences(of: ",", with: "."))!
        }
        product!.iof = swIOF.isOn
        product!.state = dataSource[pickerView.selectedRow(inComponent: 0)]
    }
    
    func stateValid() -> Bool {
        return true
    }
    
    func isValid() -> (Bool,isDecimal: Bool) {
        if tfNameProduct.text == "" {
            return (false,true)
        }
        if imgProduct.image == UIImage(named: "camera-photo") {
            return (false,true)
        }
        if tfPurchaseState.text == "" {
            return (false,true)
        }
        if tfPrice.text == "" {
            return (false,true)
        } else {
            guard let _ = Double(tfPrice.text!.replacingOccurrences(of: ",", with: ".")) else {
                return (false,false)
            }
        }
        return (true,true)
    }
    
    func showAlert(isDecimal: Bool) {
        var message = "Preencha todos os campos!"
        if !isDecimal {
            message = "O campo preço está incorreto!"
        }
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func validator() -> Bool {
        if !isValid().0 || !isValid().isDecimal {
            showAlert(isDecimal: isValid().isDecimal)
            return false
        } else {
            buildProduct()
            return true
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        imgProduct.image = smallImage
        imageSelected = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - PickerView
extension RegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let item = dataSource[row].name
        return item
    }
}

extension RegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}














