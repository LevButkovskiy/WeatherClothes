//
//  ResultViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 08/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addNewClothesButton: UIButton!
    
    var weather = Weather()
    let clothes = Clothes()
    var inventory = Inventory()

    let reuseIdentifier = "resultCell"

    override func viewDidLoad(){
        super.viewDidLoad()
        setDefaultSettings()
    }
    
    func setDefaultSettings(){
        title = "Сегодня лучше надеть эти вещи"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17.0)!]

        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        inventory.load()
        
        clothes.generateClothes(weather: weather)
    
        addNewClothesButton.layer.cornerRadius = 15
        addNewClothesButton.layer.shadowColor = UIColor.lightGray.cgColor
        addNewClothesButton.layer.shadowOpacity = 1
        addNewClothesButton.layer.shadowOffset = .zero
        addNewClothesButton.layer.shadowRadius = 3
        
        checkTheme()
    }
    
    func checkTheme(){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
            if(theme){
                setDarkTheme()
            }
            else{
                setLightTheme()
            }
        }
    }
    
    func setDarkTheme(){
        tableView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    func setLightTheme(){
        tableView.backgroundColor = .groupTableViewBackground
        view.backgroundColor = .groupTableViewBackground
        navigationController?.navigationBar.backgroundColor = .none
        navigationController?.navigationBar.barTintColor = .none
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17.0)!, NSAttributedString.Key.foregroundColor : UIColor.black]

    }
    
    func getImages(section : Int, value: String) -> Array<UIImage>{
        var images = Array<UIImage>()
        if(inventory.inventory[section] != nil){
            let typeOfClothe = inventory.inventory[section] as! Dictionary<Int, Any>
            for i in 0..<typeOfClothe.count{
                let clothe = typeOfClothe[i] as! Dictionary<String, Any>
                if(weather.temperature >= clothe["temperature"] as! Int && weather.windSpeed <= clothe["wind"] as! Int){
                    images.append(UIImage(data: (clothe["image"] as! Data))!)
                }
            }
        }
        else{
            images.append(clothes.generateImage(value: value)!)
        }
        if(images.count == 0){
            images.append(clothes.generateImage(value: value)!)
        }
        return images

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard clothes.head != "" else {
            return 3
        }
        return 4
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ResultTableViewCell
        
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 3
        
        if(clothes.head == ""){
            switch indexPath.section{
            case 0:
                cell.clotheName.text = clothes.upper
                cell.clotheDescription.text = clothes.subUpper
                cell.images = getImages(section: 1, value: clothes.upper)
            case 1:
                cell.clotheName.text = clothes.lower
                cell.images = getImages(section: 2, value: clothes.lower)
            case 2:
                cell.clotheName.text = clothes.boots
                cell.images = getImages(section: 3, value: clothes.boots)
            default:
                break
            }
        }
        else{
            switch indexPath.section{
            case 0:
                cell.clotheName.text = clothes.head
                cell.clotheDescription.text = clothes.subHead
                cell.images = getImages(section: 0, value: clothes.head)
            case 1:
                cell.clotheName.text = clothes.upper
                cell.clotheDescription.text = clothes.subUpper
                cell.images = getImages(section: 1, value: clothes.upper)
            case 2:
                cell.clotheName.text = clothes.lower
                cell.images = getImages(section: 2, value: clothes.lower)
            case 3:
                cell.clotheName.text = clothes.boots
                cell.images = getImages(section: 3, value: clothes.boots)
            default:
                break
            }
        }
        cell.loadImf()

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6 - 10
    }
}
