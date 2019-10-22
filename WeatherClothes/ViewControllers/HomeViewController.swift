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
    
    var weather = Weather()
    let clothes = Clothes()
    var inventory = Inventory()
    var settings = Settings()
    
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
        
        //checkTheme()
        setViews()
    }
    
    func afterLoadSettings(){
        if(!settings.isConnectedToNetwork()){
            //showNoInternetConnection()
            //showWhatsNew()
        }
        if (UserDefaults.standard.object(forKey: "version102") as? NSData) == nil {
            showWhatsNew("You can install WhatsNewKit via CocoaPods or Carthage")
        }

    }
    
    func showWhatsNew(_ withText: String){
        UserDefaults.standard.removeObject(forKey: "inventory")

            // Initialize WhatsNew
            let whatsNew = WhatsNew(
                // The Title
                title: "Что нового в версии 1.0.2",
                // The features you want to showcase
                items: [
                    WhatsNew.Item(
                        title: "Installation",
                        subtitle: withText,
                        image: UIImage(named: "installation")
                    ),
                    WhatsNew.Item(
                        title: "Open Source",
                        subtitle: "Contributions are very welcome 👨‍💻",
                        image: UIImage(named: "openSource")
                    )
                ]
            )
            
            // Initialize default Configuration
            var configuration = WhatsNewViewController.Configuration()
            
            // Customize Configuration to your needs
            configuration.backgroundColor = .white
            configuration.titleView.titleColor = .whatsNewKitBlue
            configuration.itemsView.titleFont = .systemFont(ofSize: 17)
            configuration.detailButton?.titleColor = .whatsNewKitBlue
            configuration.completionButton.backgroundColor = .whatsNewKitGreen
            // And many more configuration properties...
            
            //Animation
            configuration.titleView.animation = .slideRight
            configuration.itemsView.animation = .slideRight
            configuration.detailButton?.animation = .slideRight
            configuration.completionButton.animation = .slideRight
            configuration.completionButton.title = "Понятно"
        
            // Initialize WhatsNewViewController with custom configuration
            let whatsNewViewController = WhatsNewViewController(
                whatsNew: whatsNew,
                configuration: configuration
            )
            do{
                let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: true, requiringSecureCoding: true)
                UserDefaults().set(archivedObject, forKey: "version102")
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
        tableView.backgroundColor = .white

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
        inventory.update()
    }
    
    func loadWeather(){
        self.now = Date()
        self.locationManager?.stopUpdatingLocation()
        
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
                }
                
            }
        }
    }
    
    func generateClothes(){
        self.clothes.generateClothes(weather: self.weather)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        afterLoadSettings()
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
    
    func setLightTheme(){
        weatherView.backgroundColor = UIColor(red:0.59, green:0.72, blue:0.99, alpha:1.0)
        view.backgroundColor = UIColor(red:0.26, green:0.65, blue:1.00, alpha:1.0)
    }
    
    func setDarkTheme(){
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        tableView.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
    }
    
    @IBAction func showMenu(_ sender: Any) {
        menuIsActive = !menuIsActive
        //checkTheme()
        if(menuIsActive){
            menuButton.setImage(UIImage.init(named: "leftArrow"), for: .normal)
        }
        else{
            menuButton.setImage(UIImage.init(named: "menu"), for: .normal)
        }
        homeViewControllerDelegate?.toggleMenu()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        
        cell.contentView.layer.cornerRadius = 20
        cell.layer.cornerRadius = 20
        cell.backgroundColor = nil
        
        let section = clothes.head == "" ? indexPath.section + 1 : indexPath.section
        let clotheName = clothes.getNameForIndex(index: section)
        
        cell.clotheName.text = clotheName.localized
        cell.clotheDescription.text = clothes.getDescriptionForIndex(index: section)
        cell.clothesImages = clothes.getClothes(weather: weather, inventory : inventory, section: section, value: clotheName.trimmingCharacters(in: .whitespaces))
        cell.setImages()
        return cell
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        /*let subView = UIView()
        subView.frame = CGRect(x: 20, y: 40, width: view.frame.width - 40, height: view.frame.height - 80)
        subView.backgroundColor = .white
        subView.layer.cornerRadius = 10
        let blackView = UIView()
        blackView.frame = view.frame
        blackView.alpha = 0.5
        blackView.backgroundColor = .black
        view.addSubview(blackView)
        view.addSubview(subView)
        
        let button = UIButton()
        button.backgroundColor = .whatsNewKitGreen
        button.frame = CGRect(x: subView.frame.minX + 20, y: subView.frame.maxY - 10 - 30, width: subView.frame.width - 40, height: 30)
        button.layer.cornerRadius = 5
        view.addSubview(button)
        let button2 = UIButton()
        button2.backgroundColor = .whatsNewKitGreen
        button2.frame = CGRect(x: subView.frame.minX + 20, y: subView.frame.maxY - 10 - 30 - 10 - 30, width: subView.frame.width - 40, height: 30)
        button2.layer.cornerRadius = 5
        view.addSubview(button2)
        
        let title = UILabel()
        title.text = "Подписка"
        title.frame = CGRect(x: subView.frame.minX + 20, y: subView.frame.minY + 20, width: subView.frame.width - 40, height: 40)
        title.textAlignment = .center
        view.addSubview(title)*/
        performSegue(withIdentifier: "goToInventory", sender: nil)
    }
    
    @objc func closeButton(){

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(tableView.numberOfSections) - 30
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
            UIApplication.shared.open((NSURL(string:"App-Prefs:root=General&path=ManagedConfigurationList")! as URL), options: [:], completionHandler: { (true) in
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func hours() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH")
        dateFormatter.string(from: Date())
        return dateFormatter.string(from: self)
    }
    
    func minutes() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm")
        dateFormatter.string(from: Date())
        return dateFormatter.string(from: self)
    }
    
    func hoursMinutes() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        dateFormatter.string(from: Date())
        return dateFormatter.string(from: self)
    }
}



