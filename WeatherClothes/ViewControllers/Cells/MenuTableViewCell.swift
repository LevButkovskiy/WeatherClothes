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
    @IBOutlet weak var icon: UIImageView!
    
    var mode = String()
    
    var appearance = Appearance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(){
        var theme = Settings.shared().theme
        let gender = Settings.shared().gender
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        setTheme()
        if (mode == "theme"){
            switcher.addTarget(self, action: #selector(switchTheme(sender:)), for: .valueChanged)
            switcher.isOn = theme
        }
        else if(mode == "gender"){
            switcher.addTarget(self, action: #selector(switchGender(sender:)), for: .valueChanged)
            switcher.isOn = gender
            //let data = Data(
            //let a = UIImage(data: <#T##Data#>)
            icon.image = gender ? UIImage(named: "gender_woman") : UIImage(named: "gender_men")
        }
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            nameLabel.textColor = .white
            self.backgroundColor = appearance.darkThemeBlue
            icon.image = icon.image?.tinted(with: .white)
        }
        else{
            nameLabel.textColor = .black
            self.backgroundColor = appearance.lightThemeTableViewGray
            icon.image = icon.image?.tinted(with: .black)
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
    
    @objc func switchGender(sender: UISwitch){
        let viewController = (UIApplication.shared.keyWindow!.rootViewController) as! UINavigationController
        let containerViewController = viewController.viewControllers[0] as! ContainerViewController
        Settings.genderChanged(gender: sender.isOn)
        containerViewController.menuViewController.tableView.reloadData()
        containerViewController.homeViewController.generateClothes()
    }
}
