//
//  SettingsViewController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 25/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfDolarQuote: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    var list = [State]()
    var toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setToolBar()
    }
}

extension SettingsViewController {
    func setToolBar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btOk = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(newState))
        
        toolbar.items = [btCancel, btSpace, btOk]
        tfIOF.inputAccessoryView = toolbar
    }
    
    func newState() {
        let state = State()
        let alert = UIAlertController(title: "Novo", message: "Novo Estado", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Taxa de Imposto"
        }
        
        let okAction = UIAlertAction(title: "Salvar", style: .default) { (action) in
            state.name = alert.textFields![0].text
            state.tax = Double(alert.textFields![1].text!)!
            do {
                try self.context.save()
                
                self.tfDolarQuote.text = ""
                self.tfIOF.text = ""
                
            } catch {
                let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                self.present(alert,animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func cancel() {
        if tfDolarQuote.isFirstResponder {
            tfDolarQuote.resignFirstResponder()
        }
        if tfDolarQuote.isFirstResponder {
            tfIOF.resignFirstResponder()
        }
    }
    
    func delete(indexPath: IndexPath) {
        
        let state = list[indexPath.row] as State
        self.context.delete(state)
        try! self.context.save()
        
        list.remove(at: indexPath.row)
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
        
//        let editAction = UITableViewRowAction(style: .default, title: "Editar") { (action, indexPath) in
//            self.showEditAlert(task: self.list[indexPath.row])
//        }
        
        return [deleteAction]
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listCount = list.count
        if listCount == 0 {
            isEmptyList(true)
            return 0
        } else {
            return listCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellState", for: indexPath)
        return cell
    }
}
