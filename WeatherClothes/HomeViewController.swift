//
//  HomeViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import CoreLocation

protocol HomeViewControllerDelegate {
    func toggleMenu()
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var allInformationView: UIView!
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var hourlyWeatherView: UIView!
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var inventoryButton: UIButton!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var weather : Weather = Weather()
    var locationManager: CLLocationManager?
    var latitude = Double()
    var longitude = Double()

    var homeViewControllerDelegate : HomeViewControllerDelegate?
    var menuIsActive = false
    
    var refreshControl = UIRefreshControl()
    
    let bView = UIView()
    let spinner = UIActivityIndicatorView()
    
    var now = Date()

    let reuseIdentifier = "hoursWeatherCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setDefaultSettings(){

        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        collectionView.register(UINib(nibName: "WeatherUICollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.scrollView.addSubview(refreshControl)
        self.scrollView.isScrollEnabled = true
        self.scrollView.alwaysBounceVertical = true
        
        self.refreshControl.beginRefreshing()
        
        allInformationView.layer.cornerRadius = 15
        allInformationView.layer.shadowColor = UIColor.lightGray.cgColor
        allInformationView.layer.shadowOpacity = 1
        allInformationView.layer.shadowOffset = .zero
        allInformationView.layer.shadowRadius = 3

        temperatureView.layer.cornerRadius = 15
        temperatureView.layer.shadowColor = UIColor.lightGray.cgColor
        temperatureView.layer.shadowOpacity = 1
        temperatureView.layer.shadowOffset = .zero
        temperatureView.layer.shadowRadius = 3
        
        hourlyWeatherView.layer.cornerRadius = 15
        hourlyWeatherView.layer.shadowColor = UIColor.lightGray.cgColor
        hourlyWeatherView.layer.shadowOpacity = 1
        hourlyWeatherView.layer.shadowOffset = .zero
        hourlyWeatherView.layer.shadowRadius = 3
        
        detailsView.layer.cornerRadius = 15
        detailsView.layer.shadowColor = UIColor.lightGray.cgColor
        detailsView.layer.shadowOpacity = 1
        detailsView.layer.shadowOffset = .zero
        detailsView.layer.shadowRadius = 3
        
        inventoryButton.layer.cornerRadius = 15
        inventoryButton.layer.shadowColor = UIColor.lightGray.cgColor
        inventoryButton.layer.shadowOpacity = 1
        inventoryButton.layer.shadowOffset = .zero
        inventoryButton.layer.shadowRadius = 3
        
        resultButton.layer.cornerRadius = 15
        resultButton.layer.shadowColor = UIColor.lightGray.cgColor
        resultButton.layer.shadowOpacity = 1
        resultButton.layer.shadowOffset = .zero
        resultButton.layer.shadowRadius = 3
        
        weatherIconImageView.layer.cornerRadius = 15
        
        checkTheme()
        
    }
    
    func loadWeather(){
        self.now = Date()
        self.locationManager?.stopUpdatingLocation()

        weather = Weather()
        weather.initWithParams(latitude: self.latitude, longitude: self.longitude) { (completion) in
            DispatchQueue.main.async {
                if(completion){
                    self.cityLabel.text = self.weather.city
                    self.windSpeedLabel.text = String(format: "Скорость ветра: %d м/с", self.weather.windSpeed)
                    self.temperatureLabel.text = String(format: "%d˙C", self.weather.temperature)
                    self.pressureLabel.text = String(format: "Давление: %d мм.рт.ст", self.weather.pressure)
                    self.humidityLabel.text = String(format: "Влажность: %d %@", self.weather.humidity, "%")
                    self.weatherConditionLabel.text = self.weather.weatherCondition.capitalizedFirst()
                    let hours = self.now.hours()
                    let minutes = self.now.minutes()
                    self.timeLabel.text = String(format: "%@, %@", (self.now.dayOfWeek().capitalizedFirst()), self.now.hoursMinutes())
                    self.weatherIconImageView.image = self.weather.getImageForCondition(minutes: Int(minutes)!, hours: Int(hours)!, weatherCondition: self.weather.weatherCondition)
                    self.uvIndexLabel.text = String(format: "УФ индекс: %.1f", self.weather.uvIndex)
                    self.minMaxTemperatureLabel.text = String(format: "День: %d˙ | Ночь: %d˙", self.weather.tempMax, self.weather.tempMin)
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = Int(collectionView.frame.width / 70)
        if(number > 6){
            return 6
        }
        else{
            return Int(collectionView.frame.width / 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WeatherUICollectionViewCell
        if(weather.forecast[indexPath.row] != nil){
            let forecast = weather.forecast[indexPath.row] as! Dictionary<String, Any>
                cell.layer.cornerRadius = 5
            cell.time.text = (forecast["time"] as! String)
            cell.image.image = self.weather.getImageForCondition(minutes: Int(self.now.minutes())!, hours: Int(self.now.hours())!, weatherCondition: forecast["weatherCondition"] as! String)
            cell.temperature.text = String(format:"%@˙C", forecast["temperature"] as! String)
        }
        return cell;
    }
    
    
    @objc func refresh(sender:AnyObject)
    {
        loadWeather()
        locationManager?.startUpdatingLocation()
    }
    
    func showUpdateView(){
        bView.frame = view.frame
        bView.backgroundColor = .gray
        bView.alpha = 0.5
        spinner.frame = CGRect(x: bView.frame.width/2 - 50.0, y: bView.frame.height/2 - 50.0, width: 100.0, height: 100.0)
        spinner.alpha = 1.0
        spinner.style = .whiteLarge
        spinner.startAnimating()
        view.addSubview(spinner)
        view.addSubview(bView)
    }

    func setLightTheme(){
        view.backgroundColor = .groupTableViewBackground
        allInformationView.backgroundColor = .white
        temperatureView.backgroundColor = .white
        hourlyWeatherView.backgroundColor = .white
        detailsView.backgroundColor = .white
        collectionView.backgroundColor = .white
        cityLabel.textColor = .black
    }
    
    func setDarkTheme(){
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        allInformationView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        temperatureView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        hourlyWeatherView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        detailsView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        collectionView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        cityLabel.textColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
    }
    
    @IBAction func goToInventoryButton(_ sender: Any) {
        performSegue(withIdentifier: "goToInventory", sender: nil)
    }
    
    @IBAction func goToResultButton(_ sender: Any) {
        performSegue(withIdentifier: "goToResult", sender: weather)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToResult"){
            let controller = segue.destination as! ResultViewController
            if(sender != nil){
                controller.weather = sender as! Weather
            }
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        menuIsActive = !menuIsActive
        checkTheme()
        if(menuIsActive){
            menuButton.setImage(UIImage.init(named: "backArrowBlack"), for: .normal)
        }
        else{
            menuButton.setImage(UIImage.init(named: "menu"), for: .normal)
        }
        homeViewControllerDelegate?.toggleMenu()
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
}

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ru_RU")
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

extension String {
    func capitalizedFirst() -> String {
        if(self.count > 0){
            let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
            let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
            return first.uppercased() + rest.lowercased()
        }
        else{
            return self
        }
    }
}
