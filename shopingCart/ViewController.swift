//
//  ViewController.swift
//  shopingCart
//
//  Created by BRYAN RUIZ on 10/19/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tabelView: UITableView!
    var shop:[String] = []
    var alert = UIAlertController(title: "add", message: "enter the name of your item", preferredStyle: .alert)
    var alert2 = UIAlertController(title: "error", message: "already exists", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.delegate = self
        tabelView.dataSource = self
        alert2.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {
            [self,weak alert] (_) in let textField = alert?.textFields![0]
           if shop.contains((textField?.text)!) == false {
            shop.append(textField!.text!)
           } else { present(alert2, animated: true, completion: nil) }
            tabelView.reloadData()
            let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(shop) {
                    UserDefaults.standard.set(encoded, forKey: "cart")
                }
        }))
        if let item  = UserDefaults.standard.data(forKey: "cart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([String].self, from: item){
                shop = decoded
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blah", for: indexPath)
        cell.textLabel?.text = shop[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shop.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(shop) {
                    UserDefaults.standard.set(encoded, forKey: "cart")
                }
        }
        
        
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
    present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(shop) {
                UserDefaults.standard.set(encoded, forKey: "cart")
            }
        }
    }
