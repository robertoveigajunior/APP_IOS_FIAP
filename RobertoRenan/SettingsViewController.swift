//
//  SettingsViewController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 25/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

enum SettingsType: String {
    case dolar = "dolar"
    case iof = "iof"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfDolarQuote: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    
    var dataSource = [State]()
    var toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tfDolarQuote.tintColor = .black
        tfIOF.tintColor = .black
        setToolBar()
        loadTax()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadStates()
    }
    
    @IBAction func addNewState(_ sender: UIButton) {
        newState()
    }
}

//MARK: - Methods
extension SettingsViewController {
    func loadTax() {
        if let dolar = UserDefaults.standard.string(
            forKey: SettingsType.dolar.rawValue){
            tfDolarQuote.text = dolar
        }
        if let iof = UserDefaults.standard.string(forKey: SettingsType.iof.rawValue){
            tfIOF.text = iof
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func loadStates() {
        isEmptyList(true)
        dataSource.removeAll()
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try dataSource = context.fetch(fetchRequest)
            tableView.reloadData()
            if dataSource.count > 0 {
                isEmptyList(false)
            } else {
                isEmptyList(true)
            }
            
        } catch {
            print("erro")
        }
    }
    
    func setToolBar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
       let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btEdit = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(edit))
        
        toolbar.items = [btCancel,space,btEdit]
        tfDolarQuote.inputAccessoryView = toolbar
        tfIOF.inputAccessoryView = toolbar
    }
    
    func alertValidate(_ name:String, _ tax:String) -> Bool {
        var valid : Bool {
            if (!name.isEmpty && !tax.isEmpty) {
                if let _ = Double(tax) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        return valid
    }
    
    func editState(item: State) {
        let alert = UIAlertController(title: "Editar", message: "Editar Estado", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nome"
            textField.text = item.name
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Taxa de Imposto"
            textField.keyboardType = .decimalPad
            textField.text = "\(item.tax)"
        }
        
        let okAction = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if self.alertValidate(alert.textFields![0].text!,alert.textFields![1].text!) {
                item.name = alert.textFields![0].text
                if let taxState = Double(alert.textFields![1].text!) {
                    item.tax = taxState
                    do {
                        try self.context.save()
                        self.loadStates()
                    } catch {
                        
                    }
                }
                
            } else {
                self.loadStates()
                self.alertRequired()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func newState() {
        let alert = UIAlertController(title: "Novo", message: "Novo Estado", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nome"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Taxa de Imposto"
            textField.keyboardType = .decimalPad
        }
        
        let okAction = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if self.alertValidate(alert.textFields![0].text!,alert.textFields![1].text!) {
                let state = State(context: self.context)
                state.name = alert.textFields![0].text
                if let taxState = Double(alert.textFields![1].text!) {
                    state.tax = taxState
                    do {
                        try self.context.save()
                        self.loadStates()
                    } catch {
                        
                    }
                }
                
            } else {
                self.loadStates()
                self.alertRequired()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertInvalid() {
        let alert = UIAlertController(title: "Atenção",
                                      message: "Não foi possível salvar, pois a taxa de Imposto está incorreta.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
    func alertRequired() {
        let alert = UIAlertController(title: "Atenção",
                                      message: "Não foi possível salvar, pois todos os campos são obrigatórios.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
    func cancel() {
        self.becomeFirstResponder()
    }
    
    func edit() {
        if tfDolarQuote.isFirstResponder {
            UserDefaults.standard.set(tfDolarQuote.text, forKey: SettingsType.dolar.rawValue)
            self.becomeFirstResponder()
        }
        if tfIOF.isFirstResponder {
            UserDefaults.standard.set(tfIOF.text, forKey: SettingsType.iof.rawValue)
            self.becomeFirstResponder()
        }
    }
    
    func delete(indexPath: IndexPath) {
        let state = dataSource[indexPath.row] as State
        self.context.delete(state)
        try! self.context.save()
        dataSource.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func isEmptyList(_ empty: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 80))
        label.text = "Sem Estados"
        label.textAlignment = .center
        label.tintColor = .black
        label.alpha = 0.3
        tableView.backgroundView = !empty ? nil : label
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            self.delete(indexPath: indexPath)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editState(item: dataSource[indexPath.row])
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listCount = dataSource.count
        if listCount == 0 {
            isEmptyList(true)
            return 0
        } else {
            isEmptyList(false)
            return listCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellState", for: indexPath)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(String(state.tax)) %"
        return cell
    }
}
