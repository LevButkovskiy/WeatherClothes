//
//  TableViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 03.01.2020.
//  Copyright © 2020 Lev Butkovskiy. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var sections = Array<Section>()
    var rows = Array<Row>()
    
    var dateTime = Date()

    enum Row: Int {
        case Picker = 0
        case Apply
        case Cancel
    }
    
    enum Section: Int {
        case Top = 0
        case Bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TimePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "timeCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        self.view.backgroundColor = nil
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = nil
        self.view.layer.cornerRadius = 15
        
        reload()
        // Do any additional setup after loading the view.
    }

    func reload(){
        prepareSections()
        prepareRows()
        tableView.reloadData()
    }
    
    func prepareSections(){
        sections = Array<Section>()
        
        sections.append(.Top)
        sections.append(.Bottom)
    }
    
    func prepareRows(){
        rows = Array<Row>()
        
        rows.append(.Picker)
        rows.append(.Apply)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case Section.Top:
            return rows.count
        case Section.Bottom:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case Section.Top:
            switch rows[indexPath.row] {
            case Row.Picker:
                let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimePickerTableViewCell
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.layer.cornerRadius = 10
                cell.timePicker.date = dateTime
                return cell
            case Row.Apply:
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
                cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                cell.layer.cornerRadius = 10
                cell.button.setTitle("Применить", for: .normal)
                return cell
            default:
                return UITableViewCell()
            }
        case Section.Bottom:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
            cell.layer.cornerRadius = 10
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! HeaderView
        headerView.titleLabel.text = " "
        headerView.contentView.backgroundColor = nil
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .Top:
            switch rows[indexPath.row] {
            case .Apply:
                let cell = tableView.cellForRow(at: IndexPath(row: Row.Picker.rawValue, section: Section.Top.rawValue)) as! TimePickerTableViewCell
                let dateTime = cell.timePicker.date
                do{
                    let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: dateTime, requiringSecureCoding: true)
                    UserDefaults().set(archivedObject, forKey: "notificationDateTime")
                    NotificationCenter.default.post(name: .updateAfterApply, object: nil)
                    self.dismiss(animated: true, completion: nil)


                }
                catch {
                    print(error)
                }
            default:
                break;
            }
        case .Bottom:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                let d = self.tableView.frame.height - cell.frame.maxY - 30
                print(d)
                self.view.bounds = CGRect(x: 0, y: -d, width: self.tableView.bounds.width, height: self.tableView.bounds.height)
            }
        }
    }

}
