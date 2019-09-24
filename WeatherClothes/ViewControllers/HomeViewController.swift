//
//  HomeViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 02/09/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import CoreLocation

protocol HomeViewControllerDelegate {
    func toggleMenu()
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var weather = Weather()
    let clothes = Clothes()
    var inventory = Inventory()
    var detailWeatherView : DetailWeather?
    
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
        navigationController?.navigationBar.isHidden = true
    }
    
    func setDefaultSettings(){
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        /*let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(weatherViewLongPress))
        longPressRecognizer.delegate = self
        self.weatherView.addGestureRecognizer(longPressRecognizer)*/
        //checkTheme()
        setViews()

    }
    
    func setViews(){
        //setLoadingView()
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
        
        /*windLabel.text = "wind".localized
        visibilityLabel.text = "visibility".localized
        humidityLabel.text = "humidity".localized
        uvIndexLabel.text = "uvIndex".localized*/
        
        titleLabel.text = "clothesToWear".localized
    }
    
    @objc func reload(){
        //self.setLoadingView()
        weather = Weather()
        loadWeather()
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
        self.deleteLoadingView()
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
    
    func setLoadingView(){
        let lView = UIView()
        let spinner = UIActivityIndicatorView()
        lView.frame = view.frame
        lView.backgroundColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.0)
        spinner.frame = CGRect(x: view.frame.width / 2 - 15, y: view.frame.height / 2 - 15, width: 30, height: 30)
        spinner.startAnimating()
        lView.addSubview(spinner)
        view.addSubview(lView)
        UIView.animate(withDuration: 0.5, animations: {
            lView.backgroundColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.5)
        }) { (true) in
            
        }
    }
    
    func deleteLoadingView(){
        for view in view.subviews{
            if(view.backgroundColor == UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.5)){
                UIView.animate(withDuration: 0.5, animations: {
                    view.alpha = 0
                }) { (true) in
                    view.removeFromSuperview()
                }
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
            menuButton.setImage(UIImage.init(named: "backArrowBlack"), for: .normal)
        }
        else{
            menuButton.setImage(UIImage.init(named: "menu"), for: .normal)
        }
        homeViewControllerDelegate?.toggleMenu()
    }
    
    @objc func weatherViewLongPress()
    {
        if detailWeatherView != nil{
            detailWeatherView!.setWeather(weather: weather)
            detailWeatherView!.show()
            detailWeatherView!.upperPosition = tableView.frame.minY + 10
        }
        else{
            detailWeatherView = DetailWeather()
            detailWeatherView!.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
            detailWeatherView!.upperPosition = tableView.frame.minY + 10
            detailWeatherView!.backgroundColor = .white
            detailWeatherView!.setWeather(weather: weather)
            view.addSubview(detailWeatherView!)
            detailWeatherView!.show()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        UIView.animate(withDuration: 0.5, animations: {
            self.weatherView.alpha = 0.5
        }) { (true) in
            UIView.animate(withDuration: 0.25, animations: {
                self.weatherView.alpha = 1
            })
        }*/
    }
    
    func getClothes(section : Int, value: String) -> Array<Any>{
        var clothesDict = Array<Dictionary<String, Any>>()
        if(inventory.inventory[section] != nil){
            let typeOfClothe = inventory.inventory[section] as! Dictionary<Int, Any>
            for i in 0..<typeOfClothe.count{
                let clothe = typeOfClothe[i] as! Dictionary<String, Any>
                if(weather.temperature >= clothe["temperature"] as! Int && weather.windSpeed <= clothe["wind"] as! Int){
                    clothesDict.append(clothe)
                    //images.append(UIImage(data: (clothe["image"] as! Data))!)
                }
            }
            if(clothesDict.count == 0){
                print(value)
                if(value != ""){
                    let image = clothes.generateImage(value: value)!
                    var clothe = Dictionary<String, Any>()
                    clothe["image"] = image
                    clothesDict.append(clothe)
                }
            }
        }
        else{
            if(value != ""){
                let image = clothes.generateImage(value: value)!
                var clothe = Dictionary<String, Any>()
                clothe["image"] = image
                clothesDict.append(clothe)
            }
        }
        return clothesDict
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
        
        if(clothes.head == ""){
            switch indexPath.section{
            case 0:
                cell.clotheName.text = clothes.upper.trimmingCharacters(in: .whitespaces).localized
                cell.clotheDescription.text = clothes.subUpper
                cell.clothes = getClothes(section: 1, value: clothes.upper)
            case 1:
                cell.clotheName.text = clothes.lower.trimmingCharacters(in: .whitespaces).localized
                cell.clothes = getClothes(section: 2, value: clothes.lower)
            case 2:
                cell.clotheName.text = clothes.boots.trimmingCharacters(in: .whitespaces).localized
                cell.clothes = getClothes(section: 3, value: clothes.boots)
            default:
                break
            }
        }
        else{
            switch indexPath.section{
            case 0:
                cell.clotheName.text = clothes.head.trimmingCharacters(in: .whitespaces).localized
                cell.clotheDescription.text = clothes.subHead
                cell.clothes = getClothes(section: 0, value: clothes.head)
            case 1:
                cell.clotheName.text = clothes.upper.trimmingCharacters(in: .whitespaces).localized
                cell.clotheDescription.text = clothes.subUpper
                cell.clothes = getClothes(section: 1, value: clothes.upper)
            case 2:
                cell.clotheName.text = clothes.lower.trimmingCharacters(in: .whitespaces).localized
                cell.clothes = getClothes(section: 2, value: clothes.lower)
            case 3:
                cell.clotheName.text = clothes.boots.trimmingCharacters(in: .whitespaces).localized
                cell.clothes = getClothes(section: 3, value: clothes.boots)
            default:
                break
            }
        }
        cell.setImages()
        
        return cell
    
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        reload()
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView()
        if(section == 0){
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 0))
        }
        else{
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 25))
        }
        headerView.backgroundColor = UIColor.clear
        return headerView
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(tableView.numberOfSections) - 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func goToInventoryButton(_ sender: Any) {
        performSegue(withIdentifier: "goToInventory", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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



