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
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    @IBAction func switcherValueChanged(_ sender: Any) {
        if(switcher.isOn){
            setDarkTheme()
        }
        else{
            setLightTheme()
        }
        do{
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: switcher.isOn, requiringSecureCoding: true)
            UserDefaults().set(archivedObject, forKey: "theme")
        }
        catch {
            print(error)
        }
    }
}
