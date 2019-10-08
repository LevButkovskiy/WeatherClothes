//
//  TodayViewController.swift
//  WhatToWearTodayExtension
//
//  Created by Lev Butkovskiy on 08/a/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    @IBOutlet weak var mainView: UIView!
    
    var locationManager: CLLocationManager?
    var latitude = Double()
    var longitude = Double()
    
    var now = Date()
    
    var weather = Weather()
    var clothes = Clothes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateView()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        mainView.backgroundColor = nil

        // Do any additional setup after loading the view.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func generateView(){
        if(clothes.head != ""){
            let image1 = UIImageView()
            image1.frame = CGRect(x: 10, y: 10, width: (self.view.frame.width) / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image1.image = clothes.generateImage(value: clothes.head)
            mainView.addSubview(image1)
            
            let image2 = UIImageView()
            image2.frame = CGRect(x: image1.frame.maxX + 10, y: 10, width: self.view.frame.width / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image2.image = clothes.generateImage(value: clothes.upper)
            mainView.addSubview(image2)
            
            let image3 = UIImageView()
            image3.frame = CGRect(x: image2.frame.maxX + 10, y: 10, width: self.view.frame.width / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image3.image = clothes.generateImage(value: clothes.lower)
            mainView.addSubview(image3)
            
            let image4 = UIImageView()
            image4.frame = CGRect(x: image3.frame.maxX + 10, y: 10, width: self.view.frame.width / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image4.image = clothes.generateImage(value: clothes.boots)
            mainView.addSubview(image4)
        }
        else{
            let image1 = UIImageView()
            image1.frame = CGRect(x: 10, y: 10, width: (self.view.frame.width) / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image1.image = clothes.generateImage(value: clothes.upper)
            mainView.addSubview(image1)
            
            let image2 = UIImageView()
            image2.frame = CGRect(x: image1.frame.maxX + 10, y: 10, width: self.view.frame.width / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image2.image = clothes.generateImage(value: clothes.lower)
            mainView.addSubview(image2)
            
            let image3 = UIImageView()
            image3.frame = CGRect(x: image2.frame.maxX + 10, y: 10, width: self.view.frame.width / 4 - 70/4, height: self.view.frame.width / 4 - 50/4)
            image3.image = clothes.generateImage(value: clothes.boots)
            mainView.addSubview(image3)
        }
    }
    
    func loadWeather(){
        self.now = Date()
        self.locationManager?.stopUpdatingLocation()
        
        weather = Weather()
        weather.initWithParams(latitude: self.latitude, longitude: self.longitude) { (completion) in
            DispatchQueue.main.async {
                if(completion){
                    self.clothes.generateClothes(weather: self.weather)
                    self.generateView()
                }
                
            }
        }
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
        print(error)
    }
    
}
