//
//  InventoryViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 06/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let deleteAllView = UIView()
    let deleteAllButton = UIButton()
    let deleteAllLabel = UILabel()
    
    var deleteAllViewWidth : CGFloat = 0.0
    var deleteAllViewHeight : CGFloat = 0.0
    var deleteAllButtonWidth : CGFloat = 0.0
    var deleteAllButtonHeight : CGFloat = 0.0
    var deleteAllButtonX : CGFloat = 0.0

    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "inventoryCell"

    var inventory = Inventory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inventory.load()
        tableView.reloadData()
    }
    
    func setDefaultSettings(){
        title = "Ваша одежда"
        navigationController?.navigationBar.isHidden = false
        tableView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        
        deleteAllViewWidth = CGFloat(self.view.frame.width)
        deleteAllViewHeight = CGFloat(60.0)
        deleteAllButtonWidth = view.frame.width / 2.5
        deleteAllButtonHeight = deleteAllViewHeight/2
        deleteAllButtonX = deleteAllViewWidth / 2 - deleteAllButtonWidth / 2
        
        inventory.load()
        tableView.reloadData()
        
        checkTheme()
    }
    
    func checkTheme(){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
            if(theme){
                setDarkTheme()
            }
            else{
                setLightTheme()
            }
        }
    }
    
    func setDarkTheme(){
        tableView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    func setLightTheme(){
        tableView.backgroundColor = .groupTableViewBackground
        view.backgroundColor = .groupTableViewBackground
        navigationController?.navigationBar.backgroundColor = .none
        navigationController?.navigationBar.barTintColor = .none
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17.0)!, NSAttributedString.Key.foregroundColor : UIColor.black]
        
    }
    
    func showDeleteAllButton(){
        UIView.animate(withDuration: 1) {
            self.deleteAllView.frame = CGRect(x: 0, y: self.view.frame.maxY - self.deleteAllViewHeight, width: self.deleteAllViewWidth, height: self.deleteAllViewHeight)
            self.deleteAllButton.frame = CGRect(x: self.deleteAllButtonX, y: self.view.frame.maxY - self.deleteAllViewHeight + self.deleteAllButtonHeight/2, width: self.deleteAllButtonWidth, height: self.deleteAllButtonHeight)
            self.deleteAllLabel.frame = self.deleteAllButton.frame
        }
    }
    
    func hideDeleteAllButton(){
        UIView.animate(withDuration: 1) {
            self.deleteAllView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: self.deleteAllViewHeight)
            self.deleteAllButton.frame = CGRect(x: self.deleteAllButtonX, y: self.view.frame.maxY, width: self.deleteAllButtonWidth, height: self.deleteAllButtonHeight)
            self.deleteAllLabel.frame = self.deleteAllButton.frame
        }
    }
    
    func update(){
        inventory.load()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.numberOfRowsInSection(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return inventory.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! InventoryTableViewCell
        cell.clotheImage.layer.cornerRadius = 10
        let clothe = inventory.cellForRowAt(indexPath: indexPath)
        cell.clotheName.text = (clothe["name"] as! String)
        cell.comfortableTemperature.text = String(format: "Комфортная температура: %d˙C", (clothe["temperature"] as! Int))
        cell.windProtection.text = String(format: "Ветрозащита: %d м/с", (clothe["wind"] as! Int))
        cell.clotheImage.image = UIImage(data: (clothe["image"] as! Data))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        if(inventory[indexPath.section] != nil){
            let typeOfClothe = inventory[indexPath.section] as! Dictionary<Int, Any>
            let clothe = typeOfClothe[indexPath.row] as! Dictionary<String, Any>
            goToAdd(clothe)
        }*/
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
    
    @IBAction func goToAdd(_ sender: Any) {
        tableView.isEditing = false
        hideDeleteAllButton()
        if((sender as? Dictionary<String, Any>) != nil){
            performSegue(withIdentifier: "goToAdd", sender: sender)
        }
        else{
            performSegue(withIdentifier: "goToAdd", sender: nil)
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        
        deleteAllView.backgroundColor = .groupTableViewBackground
        deleteAllButton.backgroundColor = .red
        deleteAllButton.layer.cornerRadius = 10
        deleteAllLabel.text = "Удалить все"
        deleteAllLabel.textColor = .white
        deleteAllLabel.textAlignment = .center
        deleteAllLabel.font = UIFont(name: "Avenir-Heavy", size: 17.0)!
        deleteAllView.alpha = 1
        deleteAllButton.alpha = 1
        deleteAllButton.addTarget(nil, action: #selector(deleteAll), for: .touchDown)
        
        deleteAllView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: deleteAllViewWidth, height: deleteAllViewHeight)
        deleteAllButton.frame = CGRect(x: deleteAllButtonX, y: self.view.frame.maxY, width: deleteAllButtonWidth, height: deleteAllButtonHeight)
        deleteAllLabel.frame = deleteAllButton.frame
        
        self.view.addSubview(deleteAllView)
        self.view.addSubview(deleteAllButton)
        self.view.addSubview(deleteAllLabel)
        
        
        if(tableView.isEditing){
            showDeleteAllButton()
        }
        else{
            hideDeleteAllButton()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let block = UITableViewRowAction(style: .normal, title: "Изменить") { action, index in
        print("Edit")
            let clothe = self.inventory.cellForRowAt(indexPath: indexPath)
            self.goToAdd(clothe)
        }
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { action, index in
        print("Delete")
            let clothe = self.inventory.cellForRowAt(indexPath: indexPath)
            self.inventory.remove(item: clothe)
            self.update()
            }
        return [delete, block]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! HeaderView
        
        headerView.titleLabel.text = inventory.titleForHeaderInSection(section: section)
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
            if(theme){
                headerView.titleLabel.textColor = .white
                headerView.contentView.backgroundColor = UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)
            }
            else{
                headerView.titleLabel.textColor = .black
                headerView.contentView.backgroundColor = .lightGray
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height / 24
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 8
    }
        
    @objc func deleteAll() {
        let alert = UIAlertController(title: "Внимание!", message: "Вы действительно хотите удалить все вещи?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (true) in
            self.inventory.removeAll()
            self.update()
            self.tableView.isEditing = false
            self.hideDeleteAllButton()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { (true) in
            self.tableView.isEditing = false
            self.hideDeleteAllButton()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
