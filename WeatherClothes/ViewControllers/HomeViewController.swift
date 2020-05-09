//
//  HomeViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 02/09/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import CoreLocation
import WhatsNewKit
import SystemConfiguration //Internet

protocol HomeViewControllerDelegate {
    func toggleMenu()
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    let notificationCenter = Notifications()
    
    var weather = Weather()
    var weatherForecast = Weather()
    let clothes = Clothes()
    var inventory = Inventory()
    var appearance = Appearance()
    
    var counter = 0
    
    var locationManager: CLLocationManager?
    var latitude = Double()
    var longitude = Double()
    
    var homeViewControllerDelegate : HomeViewControllerDelegate?
    var menuIsActive = false
    
    var refreshControl = UIRefreshControl()
    
    let bView = UIView()
    let spinner = UIActivityIndicatorView()
    
    var now = Date()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var windHumidityLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var weatherView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inventory.update()
        tableView.reloadData()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setDefaultSettings(){
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        setTheme()
        setViews()
        
        if (UserDefaults.standard.object(forKey: "notification") as? NSData) != nil {
        }
        else{
            var notifications = Dictionary<String,Any>()
            notifications["hour"] = "09"
            notifications["minutes"] = "00"
            notifications["allowed"] = true
            do{
                let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: notifications, requiringSecureCoding: true)
                UserDefaults().set(archivedObject, forKey: "notification")
            }
            catch {
                print(error)
            }
        }
        if (UserDefaults.standard.object(forKey: "gender") as? NSData) != nil {
        }
        else{
            do{
                let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: false, requiringSecureCoding: true)
                UserDefaults().set(archivedObject, forKey: "gender")
            }
            catch {
                print(error)
            }
        }
    }
    
    func afterLoadSettings(){
        if (UserDefaults.standard.object(forKey: "version 1.0.2") as? NSData) == nil {
            UserDefaults.standard.removeObject(forKey: "inventory")
            showWhatsNew()
        }
        setTheme()
    }
    
    func showWhatsNew(){
        // Initialize WhatsNew
        let whatsNew = WhatsNew(
            // The Title
            title: "updateTitle".localized,
            // The features you want to showcase
            items: [
                WhatsNew.Item(
                    title: "darkMode".localized,
                    subtitle: "update1".localized,
                    image: UIImage(named: "darkMode")
                ),
                WhatsNew.Item(
                    title: "update2Title".localized,
                    subtitle: "update2".localized,
                    image: UIImage(named: "tshirt_white_default")
                ),
                WhatsNew.Item(
                    title: "notifications".localized,
                    subtitle: "update3".localized,
                    image: UIImage(named: "notifications")?.tinted(with: .white)
                )
            ]
        )
        // Initialize default Configuration
        var configuration = WhatsNewViewController.Configuration()
            
        // Customize Configuration to your needs
        /*if #available(iOS 13, *) {
            if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark){
                configuration.backgroundColor = .whatsNewKitDark
                configuration.itemsView.titleColor = .white
                configuration.itemsView.subtitleColor = .white
            }
            else{
                configuration.backgroundColor = .white
                configuration.itemsView.titleColor = .black
                configuration.itemsView.subtitleColor = .black
            }
        }
        else{
            configuration.backgroundColor = .white
        }*/
        configuration.backgroundColor = .whatsNewKitDark
        configuration.itemsView.titleColor = .white
        configuration.itemsView.subtitleColor = .white
        
        configuration.itemsView.autoTintImage = false
        configuration.titleView.titleColor = .whatsNewKitBlue
        configuration.itemsView.titleFont = .systemFont(ofSize: 17, weight: .heavy)
        configuration.detailButton?.titleColor = .whatsNewKitBlue
        configuration.completionButton.backgroundColor = .whatsNewKitGreen
        // And many more configuration properties...
        
        //Animation
        configuration.titleView.animation = .slideRight
        configuration.itemsView.animation = .slideRight
        configuration.detailButton?.animation = .slideRight
        configuration.completionButton.animation = .slideRight
        configuration.completionButton.title = "clearly".localized
    
        // Initialize WhatsNewViewController with custom configuration
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        do{
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: true, requiringSecureCoding: true)
            UserDefaults().set(archivedObject, forKey: "version 1.0.2")
        }
        catch {
            print(error)
        }
        // Present it 🤩
        self.present(whatsNewViewController, animated: true)
    }
    
    func setViews(){
         tableView.layer.cornerRadius = 30
        tableView.layer.shadowColor = UIColor.lightGray.cgColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        tableView.layer.shadowRadius = 1

        weatherView.layer.cornerRadius = 15
        weatherView.layer.shadowColor = UIColor.lightGray.cgColor
        weatherView.layer.shadowOpacity = 1
        weatherView.layer.shadowOffset = CGSize(width: 0, height: 1)
        weatherView.layer.shadowRadius = 1
        
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        titleLabel.text = "clothesToWear".localized
    }
    
    @objc func reload(){
        loadWeather()
        counter = 0
        inventory.update()
    }
    
    func loadWeather(){
        self.now = Date()
        self.locationManager?.stopUpdatingLocation()
        if(counter == 0){
            counter = counter + 1
        weather = Weather()
        weather.initWithParams(latitude: self.latitude, longitude: self.longitude) { (completion) in
            DispatchQueue.main.async {
                if(completion){
                    
                    self.cityLabel.text = self.weather.city
                    self.temperatureLabel.text = String(format: "%d°C", self.weather.temperature)
                    self.windHumidityLabel.text = String(format: "%@: %d %@ | %@: %d %@", "wind".localized.capitalizedFirst(), self.weather.windSpeed, "ms".localized, "humidity".localized.capitalizedFirst(), self.weather.humidity, "%")
                    //self.windValueLabel.text = String(format: "%d %@", self.weather.windSpeed, "ms".localized)
                    //self.visibilityValueLabel.text = String(format: "%.1f %@", self.weather.visibility, "km".localized)
                    //self.humidityValueLabel.text = String(format: "%d %@", self.weather.humidity, String("%"))
                    //self.uvIndexValueLabel.text = String(format: "%.1f", self.weather.uvIndex)
                    self.weatherConditionLabel.text = self.weather.weatherCondition.capitalizedFirst()
                    let hours = self.now.hours()
                    let minutes = self.now.minutes()
                    //self.timeLabel.text = String(format: "%@, %@", self.now.dayOfWeek().localized, self.now.hoursMinutes())
                    self.weatherImage.image = self.weather.getImageForCondition(minutes: Int(minutes)!, hours: Int(hours)!, weatherCondition: self.weather.weatherCondition)
                    self.generateClothes()
                    //self.loadForecast()
                }
                
            }
        }
        }
    }
    
    func loadForecast(){
        self.now = Date()
        
        weatherForecast = Weather()
        
        weatherForecast.initForForecast(latitude: self.latitude, longitude: self.longitude) { (completion) in
            DispatchQueue.main.async {
                if let unarchivedObject = UserDefaults.standard.object(forKey: "notification") as? NSData {
                    let notifications = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Dictionary<String,Any>)
                    let notificationHour = Int(notifications["hour"] as! String)
                    if(Int(self.now.hours())! <= notificationHour! + 2 && Int(self.now.hours())! >= notificationHour!){
                        var notificationText = ""
                        if(self.inventory.head == ""){
                            notificationText = String(format: "%@: %d°С, %@. %@: %@, %@, %@", "outside", self.weather.temperature, self.weather.weatherCondition, "clothesToWear".localized, self.inventory.upper, self.inventory.lower, self.inventory.boots)
                        }
                        else{
                            notificationText = String(format: "%@: %d°С, %@. %@: %@, %@, %@, %@", "outside".localized, self.weather.temperature, self.weather.weatherCondition, "clothesToWear".localized, self.inventory.head, self.inventory.upper, self.inventory.lower, self.inventory.boots)
                        }
                        print(notificationText)
                        do{
                            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: notificationText, requiringSecureCoding: true)
                            UserDefaults().set(archivedObject, forKey: "notificationText")
                        }
                        catch {
                            print(error)
                        }
                    }
                    else{
                        if(completion){
                            for i in 0..<self.weatherForecast.forecast.count{
                                let weatherPart = self.weatherForecast.forecast[i] as! Dictionary<String, Any>
                                let time = weatherPart["time"] as! String
                                let timeHour = Int(time.components(separatedBy: ":")[0])
                                if(timeHour == notificationHour! - 4 || timeHour == notificationHour! - 3 || timeHour == notificationHour! - 2){
                                    let temperature = weatherPart["temperature"] as! String
                                    var weatherCondition = weatherPart["weatherCondition"] as! String
                                    weatherCondition = weatherCondition.capitalizedFirst()
                                    var notificationText = ""
                                    if(self.inventory.head == ""){
                                        notificationText = String(format: "%@: %d°С, %@. %@: %@, %@, %@", "outside", Int(temperature)!, weatherCondition, "clothesToWear".localized, self.inventory.upper, self.inventory.lower, self.inventory.boots)
                                    }
                                    else{
                                        notificationText = String(format: "%@: %d°С, %@. %@: %@, %@, %@, %@", "outside".localized, Int(temperature)!, weatherCondition, "clothesToWear".localized, self.inventory.head, self.inventory.upper, self.inventory.lower, self.inventory.boots)
                                    }
                                    print(notificationText)
                                    do{
                                        let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: notificationText, requiringSecureCoding: true)
                                        UserDefaults().set(archivedObject, forKey: "notificationText")
                                    }
                                    catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func generateClothes(){
        self.inventory.generateClothes(weather: self.weather)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        afterLoadSettings()
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            view.backgroundColor = appearance.darkThemeBlack
            tableView.backgroundColor = appearance.darkThemeGray
        }
        else{
            view.backgroundColor = UIColor(red: 158.0/255.0, green: 201.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            tableView.backgroundColor = .white
        }
    }

    
    @IBAction func showMenu(_ sender: Any) {
        menuIsActive = !menuIsActive
        if(menuIsActive){
            menuButton.setImage(UIImage.init(named: "leftArrow"), for: .normal)
        }
        else{
            menuButton.setImage(UIImage.init(named: "menu"), for: .normal)
        }
        homeViewControllerDelegate?.toggleMenu()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard inventory.head != "" else {
            return 3
        }
        return 4
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        
        cell.contentView.layer.cornerRadius = 20
        cell.layer.cornerRadius = 20
        
        let section = inventory.head == "" ? indexPath.section + 1 : indexPath.section
        let clotheName = inventory.getNameForIndex(index: section)
        cell.clotheName.text = clotheName.removingWhitespaces().localized
        cell.clotheDescription.text = inventory.getDescriptionForIndex(index: section)
        let array = inventory.getClothes(weather: weather, section: section, value: clotheName.trimmingCharacters(in: .whitespaces))
        cell.clothes = array
        cell.collectionView.reloadData()
        
        return cell
    }
    
    func showNotificationSettings(){
        let no = NotificationSettingsViewController()
        self.modalPresentationStyle = .overFullScreen
        self.show(no, sender: nil)
        //self.present(no, animated: true, completion: nil)
        /*notificationsSettings.frame = CGRect(x: 0, y: self.view.frame.height * 2, width: self.view.frame.width, height: self.view.frame.height)
        notificationsSettings.layer.cornerRadius = 20*/
        //let no = UIViewController()
//        no.view = notificationsSettings
//        self.present(no, animated: true) {
//
//        }
        /*
        self.view.addSubview(notificationsSettings)
        self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        UIView.animate(withDuration: 0.5, animations: {
            notificationsSettings.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top + 10, width: self.view.frame.width, height: self.view.frame.height - 10)
            notificationsSettings.layer.cornerRadius = 20
        })*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(tableView.numberOfSections) - 20
    }
    
    @IBAction func goToInventoryButton(_ sender: Any) {
        performSegue(withIdentifier: "goToInventory", sender: nil)
    }
    
    //Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if(location.coordinate.latitude != self.latitude && location.coordinate.longitude != self.longitude){
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                print("Location is \(location)")
                loadWeather()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "attention".localized, message: "locationError".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Go to Settings now", style: .default, handler: { (alert: UIAlertAction!) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
              return
            }
            if UIApplication.shared.canOpenURL(settingsUrl)  {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
              }
              else  {
                UIApplication.shared.openURL(settingsUrl)
              }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any){
        performSegue(withIdentifier: "goToInventory", sender: nil)
    }
}
