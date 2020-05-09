//
//  DatePickerTableView.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 03.01.2020.
//  Copyright © 2020 Lev Butkovskiy. All rights reserved.
//

import UIKit

class DatePickerTableView: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TimePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "timeCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        self.view.backgroundColor = nil
        self.tableView.backgroundView = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimePickerTableViewCell
            cell.layer.cornerRadius = 15
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
            cell.layer.cornerRadius = 15
            return cell

        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! HeaderView
        headerView.titleLabel.text = " "
        headerView.contentView.backgroundColor = nil
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
