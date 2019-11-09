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
        title = "inventoryTitle".localized
        navigationController?.navigationBar.isHidden = false
        tableView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "inventoryCell")
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        setTheme()
        update()
    }
    
    func update(){
        inventory.load()
        tableView.reloadData()
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            view.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            tableView.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
        else{
            view.backgroundColor = .white
            tableView.backgroundColor = .white
        }
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
            let imageViews = inventory.generateImage(imageName: clothe!.imageName, color: clothe!.color)
            cell.setTheme()
            cell.clotheName.text = clothe?.name
            cell.clotheImage.setImages(backImageView: imageViews["back"] as! UIImageView, topImageView: imageViews["top"] as! UIImageView)
            cell.clotheImage.setTheme()
            cell.comfortableTemperature.text = String(format: "%@: %d˙C", "comfortableTemperature".localized, clothe!.comfortTemperature!)
            cell.windProtection.text = String(format: "%@: %d %@","windProtection".localized, clothe!.comfortWind!, "ms".localized)
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
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            headerView.contentView.backgroundColor = UIColor(red: 30.0/255.0, green: 32.0/255.0, blue: 35.0/255.0, alpha: 1.0)
            headerView.titleLabel.textColor = .white
        }
        else{
            headerView.contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            headerView.titleLabel.textColor = .black
        }
    
        return headerView
    }
    
    @IBAction func editButton(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /*let block = UITableViewRowAction(style: .normal, title: "Изменить") { action, index in
            print("Edit")
            let clothe = self.inventory.cellForRowAt(indexPath: indexPath)
            self.goToAdd(clothe!)
        }*/
        let delete = UITableViewRowAction(style: .default, title: "delete".localized) { action, index in
            print("delete")
            let clothe = self.inventory.cellForRowAt(indexPath: indexPath)
            self.inventory.remove(clothe: clothe!)
            self.update()
        }
        return [delete/*, block*/]
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
