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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        setTheme()
        if (mode == "theme"){
            switcher.addTarget(self, action: #selector(switchTheme(sender:)), for: .valueChanged)
            switcher.isOn = theme
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
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            nameLabel.textColor = .white
            self.backgroundColor = UIColor(red: 30.0/255.0, green: 32.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        }
        else{
            nameLabel.textColor = .black
            self.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        }
    }
    
    @objc func switchTheme(sender: UISwitch){
        let viewController = (UIApplication.shared.keyWindow!.rootViewController) as! UINavigationController
        let containerViewController = viewController.viewControllers[0] as! ContainerViewController
        Settings.themeChanged(theme: switcher.isOn)
        containerViewController.homeViewController.tableView.reloadData()
        containerViewController.homeViewController.setTheme()
        containerViewController.menuViewController.tableView.reloadData()
        containerViewController.menuViewController.setTheme()
    }
}
