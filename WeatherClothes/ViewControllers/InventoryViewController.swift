//
//  InventoryViewController.swift
//  
//
//  Created by Lev Butkovskiy on 12/10/2019.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var inventory = Inventory()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    func setDefaultSettings(){
        title = "Ваша одежда"
        navigationController?.navigationBar.isHidden = false
        tableView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "inventoryCell")
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        
        update()
    }
    
    func update(){
        inventory.load()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return inventory.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryCell", for: indexPath) as! InventoryTableViewCell
        let clothe = inventory.cellForRowAt(indexPath: indexPath)
        if(clothe != nil){
            cell.clotheName.text = clothe?.name
            cell.clotheImage.image = UIImage(named: clothe!.imageNamed)
            cell.comfortableTemperature.text = String(format: "Комфортная температура: %d˙C", clothe!.comfortTemperature!)
            cell.windProtection.text = String(format: "Ветрозащита: %d м/с", clothe!.comfortWind!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height / 24
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! HeaderView
        headerView.titleLabel.text = inventory.titleForHeaderInSection(section: section)
        headerView.contentView.backgroundColor = .groupTableViewBackground
    
        return headerView
    }
    
    @IBAction func editButton(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let block = UITableViewRowAction(style: .normal, title: "Изменить") { action, index in
            print("Edit")
            let clothe = self.inventory.cellForRowAt(indexPath: indexPath)
            self.goToAdd(clothe!)
        }
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { action, index in
            print("Delete")
            let clothe = self.inventory.cellForRowAt(indexPath: indexPath)
            self.inventory.remove(clothe: clothe!)
            self.update()
        }
        return [delete, block]
    }
    
    @IBAction func goToAdd(_ sender: Any) {
        //tableView.isEditing = false
        if(sender as? Clothe != nil){
            performSegue(withIdentifier: "goToAdd", sender: sender)
        }
        else{
            performSegue(withIdentifier: "goToAdd", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
/*
 
 

 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return inventory.numberOfRowsInSection(section: section)
 }
 
 func numberOfSections(in tableView: UITableView) -> Int {
 return inventory.numberOfSections()
 }

 func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 return true
 }
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 if(segue.identifier == "goToAdd"){
 let controller = segue.destination as! AddClotheViewController
 if(sender != nil){
 controller.clothe = sender as! Dictionary<String, Any>
 }
 controller.inventory = self.inventory
 }
 }
 }
*/
