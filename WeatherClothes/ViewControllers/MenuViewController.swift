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
        // Do any additional setup after loading the view.
    }
    
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .groupTableViewBackground
        tableView.allowsSelection = false
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuTableViewCell
        switch indexPath.row {
        /*case 0:
            cell.nameLabel.text = "nightTheme".localized
            cell.switcher.isHidden = false
            cell.mode = "theme"*/
        case 0:
            cell.mode = "gender"
            cell.nameLabel.text = "gender".localized
            cell.switcher.isHidden = false
            cell.switcher.onTintColor = UIColor(red:1.00, green:0.54, blue:0.98, alpha:1.0)
            cell.switcher.tintColor = .blue
            cell.switcher.layer.cornerRadius = cell.switcher.frame.height / 2
            cell.switcher.backgroundColor = .blue
        default: break
        }
        cell.setValues()
        return cell
    }
}
