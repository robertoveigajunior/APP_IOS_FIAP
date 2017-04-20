//
//  ListShoppingTableViewController.swift
//  RobertoRenan
//
//  Created by Roberto Luiz Veiga Junior on 26/03/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

class ListShoppingTableViewController: UITableViewController {

    var dataSource = [Product]()
    let sgEditProduct = "sgEditProduct"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listCount = dataSource.count
        if listCount == 0 {
            isEmptyList(true)
            return 0
        } else {
            isEmptyList(false)
            return listCount
        }
    }
    
    func isEmptyList(_ empty: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 80))
        label.text = "Sem produtos"
        label.textAlignment = .center
        label.tintColor = .black
        label.alpha = 0.3
        tableView.backgroundView = !empty ? nil : label
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath)
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.price.currencyDolar
        if let image = item.image {
            cell.imageView?.image = image as? UIImage
            cell.imageView?.setBorder()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            self.delete(indexPath)
        }

        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        performSegue(withIdentifier: sgEditProduct, sender: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListShoppingTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sgEditProduct {
            let product = sender as! Product
            let vcDestination = segue.destination as! RegisterViewController
            vcDestination.product = product
        }
    }
    
    func delete(indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        let product = dataSource[indexPath.row] as Product
        self.context.delete(product)
        try! self.context.save()
    }

    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try dataSource = context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("erro")
        }
    }
}
