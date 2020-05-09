//
//  MenuViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 19/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import ApphudSDK
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier = "menuCell"
    var tableView : UITableView!
    
    var appearance = Appearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setTheme()
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            tableView.backgroundColor = appearance.darkThemeBlue
        }
        else{
            tableView.backgroundColor = appearance.lightThemeTableViewGray
        }
    }
    
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.65, height: self.view.frame.height)
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if #available(iOS 13, *) {
            return Apphud.hasActiveSubscription() ? 3 : 4
        }
        else{
            return Apphud.hasActiveSubscription() ? 4 : 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        cell.setTheme()
        if #available(iOS 13, *) {
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "whatsNew".localized
                cell.accessoryType = .disclosureIndicator
                cell.icon.image = UIImage(named: "updates")
            case 1:
                cell.nameLabel.text = "notifications".localized
                cell.accessoryType = .disclosureIndicator
                cell.icon.image = UIImage(named: "notifications")
            case 2:
                cell.mode = "gender"
                cell.nameLabel.text = "gender".localized
                cell.switcher.isHidden = false
                cell.switcher.onTintColor = UIColor(red:1.00, green:0.54, blue:0.98, alpha:1.0)
                cell.switcher.tintColor = .blue
                cell.switcher.layer.cornerRadius = cell.switcher.frame.height / 2
                cell.switcher.backgroundColor = .blue
                cell.selectionStyle = .none
            case 3:
                cell.mode = "subscription"
                cell.nameLabel.text = "Новые функции";
                cell.accessoryType = .disclosureIndicator
                cell.icon.image = UIImage(named: "updates")

            default: break
            }
        }
        else{
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "whatsNew".localized
                cell.accessoryType = .disclosureIndicator
                cell.icon.image = UIImage(named: "updates")
            case 1:
                cell.nameLabel.text = "notifications".localized
                cell.accessoryType = .disclosureIndicator
                cell.icon.image = UIImage(named: "notifications")
            case 2:
                cell.mode = "theme"
                cell.nameLabel.text = "darkMode".localized
                cell.switcher.isHidden = false
                cell.icon.image = UIImage(named: "darkMode")
                cell.selectionStyle = .none
            case 3:
                cell.mode = "gender"
                cell.nameLabel.text = "gender".localized
                cell.switcher.isHidden = false
                cell.switcher.onTintColor = UIColor(red:1.00, green:0.54, blue:0.98, alpha:1.0)
                cell.switcher.tintColor = .blue
                cell.switcher.layer.cornerRadius = cell.switcher.frame.height / 2
                cell.switcher.backgroundColor = .blue
                cell.selectionStyle = .none
            case 4:
                cell.mode = "subscription"
                cell.nameLabel.text = "Новые функции";
                cell.accessoryType = .disclosureIndicator
                cell.icon.image = UIImage(named: "updates")
            default: break
            }
        }
    
        cell.setValues()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        let viewController = (UIApplication.shared.keyWindow!.rootViewController) as! UINavigationController
        let containerViewController = viewController.viewControllers[0] as! ContainerViewController
        containerViewController.homeViewController.showMenu(self)
        
        if(indexPath.row == 0){
            containerViewController.homeViewController.showWhatsNew()
        }
        if(indexPath.row == 1){
            if(Apphud.hasActiveSubscription()){
                containerViewController.homeViewController.showNotificationSettings()
            }
            else{
                containerViewController.homeViewController.showSubscription()
            }
        }
        
        if(cell.mode == "subscription") {
            containerViewController.homeViewController.showSubscription()
        }
    }

}
