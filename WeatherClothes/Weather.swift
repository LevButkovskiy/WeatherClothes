//
//  Weather.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 06/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit



class Weather: NSObject {
    let nightTimeStart = 22
    let nightTimeFinish = 5
    
    var city = String()
    var temperature = Int()
    var windSpeed = Int()
    var pressure = Int()
    var humidity = Int()
    var uvIndex = Double()
    var weatherCondition = String()
    var sunriseTimeHours = Int()
    var sunriseTimeMinutes = Int()
    var sunsetTimeHours = Int()
    var sunsetTimeMinutes = Int()
    var tempMin = Int()
    var tempMax = Int()

    var forecast = Dictionary<Int, Any>()
    
    override init(){
        super.init()
    }
    func initWithParams(latitude: Double, longitude: Double, completion: @escaping ((Bool) -> ())) {
        tempMax = -999
        tempMin = 999
        let api = API()
        api.load(latitude: latitude, longitude: longitude, language: "ru", params: "Сейчас"){json in
            self.city = json["name"] as! String
            let main = json["main"] as! Dictionary<String, Any>
            self.temperature = Int(truncating: main["temp"] as! NSNumber)
            self.pressure = Int((main["pressure"] as! Double) * 0.75006375541921)
            self.humidity = main["humidity"] as! Int
            let wind = json["wind"] as! Dictionary<String, Any>
            self.windSpeed = Int(truncating: wind["speed"] as! NSNumber)
            let weather = (json["weather"] as! NSArray).mutableCopy() as! NSMutableArray
            let subWeather = weather.firstObject as! Dictionary<String, Any>
            self.weatherCondition = subWeather["description"] as! String
            self.sunriseTimeHours = Int(self.getSunSetRice(value: "sunrise", json: json, formatter: "HH"))!
            self.sunriseTimeMinutes = Int(self.getSunSetRice(value: "sunrise", json: json, formatter: "mm"))!
            self.sunsetTimeHours = Int(self.getSunSetRice(value: "sunset", json: json, formatter: "HH"))!
            self.sunsetTimeMinutes = Int(self.getSunSetRice(value: "sunset", json: json, formatter: "mm"))!
            api.loadUVIndex(latitude: latitude, longitude: longitude) { json in
                self.uvIndex = json["value"] as! Double
                api.load(latitude: latitude, longitude: longitude, language: "ru", params: "3 часа"){jsonForecast in
                    self.parseJsonForecast(json: jsonForecast)
                    completion(true)
                }
            }
        }
    }
    
    func parseJsonForecast(json : Dictionary<String, Any>){
        let list = json["list"] as! NSArray
        let city = json["city"] as! Dictionary<String, Any>
        let timeZone = city["timezone"] as! Int
        for i in 2..<7{
            let item = list[i] as! Dictionary<String, Any>
            var weather = Dictionary<String, Any>()
            let main = item["main"] as! Dictionary<String, Any>
            let weatherDesc = (item["weather"] as! NSArray).mutableCopy() as! NSMutableArray
            let subWeather = weatherDesc.firstObject as! Dictionary<String, Any>

            weather["temperature"] = String(format: "%i", Int(truncating: main["temp"] as! NSNumber))
            weather["time"] = dateFromString(string : item["dt_txt"] as! String, timeZone: timeZone)
            weather["weatherCondition"] = subWeather["description"] as! String
            forecast[i-2] = weather
        }
        for i in 0..<8{
            let item = list[i] as! Dictionary<String, Any>
            let main = item["main"] as! Dictionary<String, Any>
            let tempMin = Int(truncating: main["temp_min"] as! NSNumber)
            let tempMax = Int(truncating: main["temp_max"] as! NSNumber)
            if(tempMin < self.tempMin){
                self.tempMin = tempMin
            }
            if(tempMax > self.tempMax){
                self.tempMax = tempMax
            }
        }
    }
    
    func dateFromString(string : String, timeZone : Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timeZone)
        let date = dateFormatter.date(from: string)
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "HH:mm"
        return newFormatter.string(from: date!)
        
    }
    
    func getSunSetRice(value : String, json : Dictionary<String, Any>, formatter : String) -> String{
        let sys = json["sys"] as! Dictionary <String, Any>
        let date = Date(timeIntervalSince1970: sys[value] as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.timeZone = TimeZone(secondsFromGMT: ((json["timezone"] as! Int)))
        return dateFormatter.string(from: date)
    }

    func getTimeDesription(hours: Int, minutes: Int) -> String{
        if(hours > self.sunsetTimeHours || hours < self.sunriseTimeHours){
            return "Night"
        }
        else if(hours == self.sunsetTimeHours || hours == self.sunriseTimeHours){
            if(hours == self.sunsetTimeHours){
                if(minutes >= self.sunsetTimeMinutes){
                    return "Night"
                }
                else{
                    return "Day"
                }
            }
            else if(hours == self.sunriseTimeHours){
                if(minutes >= self.sunriseTimeMinutes){
                    return "Day"
                }
                else{
                    return "Night"
                }
            }
            else{
                return ""
            }
        }
        else{
            return "Day"
        }
    }
    
    func getImageForCondition(minutes: Int, hours: Int, weatherCondition: String) -> UIImage?{
        if(weatherCondition == "облачно"){
            return UIImage(named: String(format: "Cloudy%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "слегка облачно"){
            return UIImage(named: String(format: "PartyCloudy%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "ясно"){
            return UIImage(named: String(format: "Clear%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "пасмурно"){
            return UIImage(named: String(format: "Cloudy%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "туман" || weatherCondition == "туманно"){
            return UIImage(named: String(format: "Fog%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "дождь" ){
            return UIImage(named: String(format: "Rain%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "легкий дождь"){
            return UIImage(named: String(format: "LightRain%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "сильный дождь" ){
            return UIImage(named: String(format: "HeavyRain%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "гроза" ){
            return UIImage(named: String(format: "Thunderstorm%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "гроза с мелким дождём" ){
            return UIImage(named: String(format: "ThunderstormRain%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else if(weatherCondition == "снег" ){
            return UIImage(named: String(format: "Snow%@", getTimeDesription(hours: hours, minutes: minutes)))!
        }
        else{
            return nil
        }
    }
}
