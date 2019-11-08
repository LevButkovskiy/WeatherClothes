//
//  MenuViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 19/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier = "menuCell"
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setTheme()
    }
    func setTheme(){
        let settings = Settings.shared()
        let theme = settings.theme
        if(theme){
            tableView.backgroundColor = UIColor(red: 30.0/255.0, green: 32.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        }
        else{
            tableView.backgroundColor = .white
        }
    }
    
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.6, height: self.view.frame.height)
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        cell.setTheme()
        switch indexPath.row {
        case 0:
            cell.mode = "gender"
            cell.nameLabel.text = "gender".localized
            cell.switcher.isHidden = false
            cell.switcher.onTintColor = UIColor(red:1.00, green:0.54, blue:0.98, alpha:1.0)
            cell.switcher.tintColor = .blue
            cell.switcher.layer.cornerRadius = cell.switcher.frame.height / 2
            cell.switcher.backgroundColor = .blue
            cell.selectionStyle = .none
        case 1:
            cell.mode = "theme"
            cell.nameLabel.text = "nightTheme".localized
            cell.switcher.isHidden = false
            cell.selectionStyle = .none
        case 2:
            cell.nameLabel.text = "Уведомления"
            cell.accessoryType = .disclosureIndicator
        default: break
        }
        cell.setValues()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
    }

}
