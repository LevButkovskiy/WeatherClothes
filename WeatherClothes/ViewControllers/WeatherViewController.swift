//
//  WeatherViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var weather : Weather = Weather()
    
    let reuseIdentifier = "hoursWeatherCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setDefaultSettings(){
       // checkTheme()
        
    }
    
    func loadWeather(){
        /*
        self.now = Date()
        self.locationManager?.stopUpdatingLocation()

        weather = Weather()
        weather.initWithParams(latitude: self.latitude, longitude: self.longitude) { (completion) in
            DispatchQueue.main.async {
                if(completion){
                    self.cityLabel.text = self.weather.city
                    self.windSpeedLabel.text = String(format: "%@: %d %@", "windSpeed".localized, self.weather.windSpeed, "ms".localized)
                    self.temperatureLabel.text = String(format: "%d°C", self.weather.temperature)
                    self.pressureLabel.text = String(format: "%@: %d %@", "pressure".localized, self.weather.pressure, "mmHg".localized)
                    self.humidityLabel.text = String(format: "%@: %d %@", "humidity".localized, self.weather.humidity, String("%"))
                    self.weatherConditionLabel.text = self.weather.weatherCondition.capitalizedFirst()
                    let hours = self.now.hours()
                    let minutes = self.now.minutes()
                    self.timeLabel.text = String(format: "%@, %@", self.now.dayOfWeek().localized, self.now.hoursMinutes())
                    self.weatherIconImageView.image = self.weather.getImageForCondition(minutes: Int(minutes)!, hours: Int(hours)!, weatherCondition: self.weather.weatherCondition)
                    self.uvIndexLabel.text = String(format: "%@: %.1f", "uvIndex".localized, self.weather.uvIndex)
                    self.minMaxTemperatureLabel.text = String(format: "%@: %d° | %@: %d°", "day".localized, self.weather.tempMax, "night".localized, self.weather.tempMin)
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
            }
        }*/
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WeatherUICollectionViewCell
        if(weather.forecast[indexPath.row] != nil){
            let forecast = weather.forecast[indexPath.row] as! Dictionary<String, Any>
                cell.layer.cornerRadius = 5
            cell.time.text = (forecast["time"] as! String)
            cell.image.image = self.weather.getImageForCondition(minutes: Int(self.now.minutes())!, hours: Int(self.now.hours())!, weatherCondition: forecast["weatherCondition"] as! String)
            cell.temperature.text = String(format:"%@°C", forecast["temperature"] as! String)
        }
        return cell;
    }*/
    
    
    @objc func refresh(sender:AnyObject)
    {
        loadWeather()
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
        view.backgroundColor = .groupTableViewBackground
        cityLabel.textColor = .black
    }
    
    func setDarkTheme(){
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        cityLabel.textColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US")
        let f = dateFormatter.string(from: self)
        print(f)
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
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
