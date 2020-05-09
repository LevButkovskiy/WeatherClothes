//
//  NotificationSettingsViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 30.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit


class NotificationSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Section: Int {
        case Notifications = 0
        case Time
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    var appearance = Appearance()
    
    var allowNotifications = Bool()
    var timeText = String()
    var notifications = Dictionary<String,Any>()
    
    var sections = Array<Section>()
    var footerTitles = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        navigationBar.topItem?.title = "notifications".localized
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        tableView.register(UINib(nibName: "SetValueTableViewCell", bundle: nil), forCellReuseIdentifier: "setValueCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        tableView.register(UINib(nibName: "FooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "footerView")

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "notification") as? NSData {
            self.notifications = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Dictionary<String,Any>)
            allowNotifications = notifications["allowed"] as! Bool
            reload()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterApply), name: .updateAfterApply, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func reload(){
        prepareSections()
        prepareFooterTitles()
        tableView.reloadData()
    }
    
    @objc func reloadAfterApply(){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "notificationDateTime") as? NSData {
            let dateTime = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Date)
            
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.Time.rawValue)) as! SetValueTableViewCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeText = dateFormatter.string(from: dateTime)
            self.timeText = timeText
            cell.valueLabel.text = timeText
            applyChanges()
            reload()
        }
       
    }
    
    func prepareSections(){
        sections = Array<Section>()
        
        sections.append(Section.Notifications)
        sections.append(Section.Time)
    }
    
    func prepareFooterTitles(){
        footerTitles = Array<String>()
        for section in sections{
            switch section {
            case .Notifications:
                footerTitles.append("notificationsFooter".localized)
                break;
            case .Time:
                footerTitles.append("Время срабатывания уведомления")
                break;
            }
        }
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            navigationBar.backgroundColor = appearance.darkThemeBlack
            tableView.backgroundColor = appearance.darkThemeBlack
        }
        else{
            navigationBar.backgroundColor = appearance.lightThemeTableViewGray
            tableView.backgroundColor = appearance.lightThemeTableViewGray
            self.view.backgroundColor = appearance.lightThemeTableViewGray
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case Section.Notifications:
               let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
                cell.selectionStyle = .none
                cell.setTheme()
                cell.switcher.isOn = allowNotifications
                cell.switcher.addTarget(self, action: #selector(notificationSwitcherValueChanged(sender:)), for: .valueChanged)
                return cell
        case Section.Time:
            let cell = tableView.dequeueReusableCell(withIdentifier: "setValueCell", for: indexPath) as! SetValueTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.setTheme()
            if(notifications["hour"] != nil){
                cell.valueLabel.text = String(format: "%@:%@", notifications["hour"] as! String, notifications["minutes"] as! String)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height / 48
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerView") as! FooterView
        footerView.contentView.backgroundColor = Appearance().lightThemeTableViewGray
        footerView.titleLabel.text = footerTitles[section]
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! HeaderView
        headerView.titleLabel.text = " "
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == Section.Time.rawValue){
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.Time.rawValue)) as! SetValueTableViewCell
            //let timeValue = cell.valueLabel.text!
            //print(timeValue)
            let time = cell.valueLabel.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"

            let fullDate = dateFormatter.date(from: time!)
            print(fullDate)
            dateFormatter.dateFormat = "hh:mm:ss"
            let vc = TableViewController()
            vc.dateTime = fullDate!

            /*let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 18000)
            let timeValue = "08:20"
            print(timeValue)
            print(dateFormatter.dateFormat)
            print(dateFormatter.date(from: timeValue))
            let dateTime = dateFormatter.date(from: timeValue)
            let vc = TableViewController()
            vc.dateTime = dateTime!
            
            self.present(vc, animated: true, completion: nil)*/
        }
    }
    
    /*@objc func timePickerValueChanged(sender: UIDatePicker){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.Time.rawValue)) as! SetValueTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeText = dateFormatter.string(from: sender.date)
        cell.valueLabel.text = timeText
        applyChanges()
        print(timeText)
    }*/
    
    @objc func notificationSwitcherValueChanged(sender: UISwitch){
        allowNotifications = sender.isOn
        applyChanges()
    }
    
    @objc func applyChanges(){
        notifications["allowed"] = allowNotifications
        if(timeText != ""){
            let hour = timeText.components(separatedBy: ":")[0]
            let minutes = timeText.components(separatedBy: ":")[1]
            notifications["hour"] = hour
            notifications["minutes"] = minutes
        }
        do{
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: notifications, requiringSecureCoding: true)
            UserDefaults().set(archivedObject, forKey: "notification")
        }
        catch {
            print(error)
        }
    }
}
