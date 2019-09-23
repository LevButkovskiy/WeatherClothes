//
//  MenuTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 19/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    static let reuseId = "MenuTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    var mode = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .groupTableViewBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(){
        if (mode == "theme"){
            if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
                let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
                if(theme){
                    switcher.isOn = theme
                    setDarkTheme()
                }
                else{
                    switcher.isOn = false
                    setLightTheme()
                }
            }
        }
        else if(mode == "gender"){
            if let unarchivedObject = UserDefaults.standard.object(forKey: "gender") as? NSData {
                let gender = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
                if(gender){
                    switcher.isOn = gender
                }
                else{
                    switcher.isOn = false
                }
            }
        }
    }
    
    func setDarkTheme(){
        let viewController = (UIApplication.shared.keyWindow!.rootViewController) as! UINavigationController
        let containerViewController = viewController.viewControllers[0] as! ContainerViewController
        
        nameLabel.textColor = .white
        self.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        containerViewController.menuViewController.tableView.backgroundColor = UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
        containerViewController.homeViewController.setDarkTheme()
    }
    
    func setLightTheme(){
        let viewController = (UIApplication.shared.keyWindow!.rootViewController) as! UINavigationController
        let containerViewController = viewController.viewControllers[0] as! ContainerViewController
        
        nameLabel.textColor = .black
        self.backgroundColor = .white
        containerViewController.menuViewController.tableView.backgroundColor = .white
        containerViewController.homeViewController.setLightTheme()
    }
    
    func reloadView(){
        let viewController = (UIApplication.shared.keyWindow!.rootViewController) as! UINavigationController
        let containerViewController = viewController.viewControllers[0] as! ContainerViewController

        containerViewController.homeViewController.generateClothes()
    }
    
    @IBAction func switcherValueChanged(_ sender: Any) {
        if (mode == "theme"){
            do{
                let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: switcher.isOn, requiringSecureCoding: true)
                UserDefaults().set(archivedObject, forKey: "theme")
                if(switcher.isOn){
                    setDarkTheme()
                }
                else{
                    setLightTheme()
                }
            }
            catch {
                print(error)
            }
        }
        else if(mode == "gender"){
            do{
                let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: switcher.isOn, requiringSecureCoding: true)
                UserDefaults().set(archivedObject, forKey: "gender")
                reloadView()
            }
            catch {
                print(error)
            }
        }
    }
}
