//
//  API.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 27/07/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class API: NSObject {
    let openWeatherMapAPIKey = "06db44f389d2172e9b1096cdce7b051c"
    
    func load(latitude: Double, longitude: Double, language: String, params: String, completion: @escaping (Dictionary<String, Any>) -> ()){
        let type = params == "Сейчас" ? "weather" : "forecast"
        
        let APPID = "be1791235ccb226035fc36eae1293677"
    
        let query = String(format: "https://api.openweathermap.org/data/2.5/%@?lat=%.2f&lon=%.2f&APPID=%@&units=metric&lang=%@", type, latitude, longitude, APPID, language)
        
        guard let url = URL(string: query) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                completion(jsonArray)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()

    }
    
    func loadUVIndex(latitude: Double, longitude: Double, completion: @escaping (Dictionary<String, Any>) -> ()){
        
        let query = String(format: "https://api.openweathermap.org/data/2.5/uvi?appid=%@&lat=%.2f&lon=%.2f&", openWeatherMapAPIKey, latitude, longitude)
        
        guard let url = URL(string: query) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                completion(jsonArray)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
}

