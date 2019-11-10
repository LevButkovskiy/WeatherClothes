//
//  NotificationSettings.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class NotificationSettings: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!

    var allowNotifications = Bool()
    var pickerIsActive = Bool()
    var timeText = String()
    var notifications = Dictionary<String,Any>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("NotificationSettings", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setTheme()
        navigationBar.topItem?.title = "notifications".localized
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        tableView.register(UINib(nibName: "SetValueTableViewCell", bundle: nil), forCellReuseIdentifier: "setValueCell")
        tableView.register(UINib(nibName: "TimePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "timePickerCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerView")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        pickerIsActive = false
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "notification") as? NSData {
            self.notifications = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Dictionary<String,Any>)
            allowNotifications = notifications["allowed"] as! Bool
            tableView.reloadData()
        }
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            navigationBar.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            tableView.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
        else{
            navigationBar.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            tableView.backgroundColor = .white
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pickerIsActive ? 4 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(pickerIsActive){
            switch  indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
                cell.selectionStyle = .none
                cell.setTheme()
                cell.switcher.isOn = allowNotifications
                cell.switcher.addTarget(self, action: #selector(notificationSwitcherValueChanged(sender:)), for: .valueChanged)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "setValueCell", for: indexPath) as! SetValueTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.setTheme()
                if(notifications["hour"] != nil){
                    cell.valueLabel.text = String(format: "%@:%@", notifications["hour"] as! String, notifications["minutes"] as! String)
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "timePickerCell", for: indexPath) as! TimePickerTableViewCell
                cell.setTheme()
                cell.timePicker.addTarget(self, action: #selector(timePickerValueChanged(sender:)), for: .valueChanged)
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
                cell.setTheme()
                cell.button.addTarget(self, action: #selector(applyChanges), for: .touchDown)
                return cell
            default:
                let cell = UITableViewCell()
                return cell
            }
        }
        else{
            switch  indexPath.section {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
                    cell.selectionStyle = .none
                    cell.setTheme()
                    cell.switcher.isOn = allowNotifications
                    cell.switcher.addTarget(self, action: #selector(notificationSwitcherValueChanged(sender:)), for: .valueChanged)
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "setValueCell", for: indexPath) as! SetValueTableViewCell
                    cell.accessoryType = .disclosureIndicator
                    cell.setTheme()
                    if(notifications["hour"] != nil){
                        cell.valueLabel.text = String(format: "%@:%@", notifications["hour"] as! String, notifications["minutes"] as! String)
                    }
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
                    cell.setTheme()
                    cell.button.addTarget(self, action: #selector(applyChanges), for: .touchDown)
                    return cell
                default:
                    let cell = UITableViewCell()
                    return cell
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return frame.height / 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerView") as! HeaderView
        headerView.titleLabel.text = " "
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            headerView.contentView.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
        else{
            headerView.contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        }
    
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(pickerIsActive){
            switch indexPath.section{
            case 0: return frame.height / 8
            case 1: return frame.height / 10
            case 2: return frame.height / 8
            case 3: return frame.height / 10
            default:
                return 30
            }
        }
        else{
            switch indexPath.section{
            case 0: return frame.height / 8
            case 1: return frame.height / 10
            case 2: return frame.height / 10
            default:
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!pickerIsActive && indexPath.section == 1){
            pickerIsActive = true
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SetValueTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeText = dateFormatter.string(from: sender.date)
        cell.valueLabel.text = timeText
        print(timeText)
    }
    
    @objc func notificationSwitcherValueChanged(sender: UISwitch){
        allowNotifications = sender.isOn
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

        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: self.frame.height)
        }) { (completion) in
            self.removeFromSuperview()
            
        }
    }

}
