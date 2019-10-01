//
//  Clothes.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 21/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class Clothes: NSObject {
    
    var head = String()
    var headDescription = String()
    var upper = String()
    var upperDescription = String()
    var lower = String()
    var lowerDescription = String()
    var boots = String()
    var bootsDescription = String()
    var gender = Bool()
    var chill = Double()
    var dict = Dictionary<String, Any>()

    
    /*func generateClothesOld(weather : Weather){
        //generateClothesNew(weather: weather)
        if(gender == false){
            if (weather.windSpeed < 5 && weather.windSpeed >= 0){
                if (weather.temperature >= 25){
                    head = "Cap"
                    upper = "T-Shirt"
                    lower = "Shorts"
                    boots = "Sneakers"
                } else if (weather.temperature >= 20 && weather.temperature < 25){
                    head = "Cap"
                    upper = "T-Shirt"
                    lower = "Shorts"
                    boots = "Sneakers"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Hoodie"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature >= 10 && weather.temperature < 15){
                    upper = "WindBreaker"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature >= 0 && weather.temperature < 10){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "Jacket"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature >= -10 && weather.temperature < 0){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature >= -20 && weather.temperature < -10){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie и перчатки"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature < -20){
                    head = "Insulated Hat"
                    upper = "Insulated Jacket"
                    subUpper = "А еще теплая Hoodie и перчатки"
                    lower = "Pants"
                    boots = "Winter Shoes"
                }
            } else if (weather.windSpeed >= 5){
                if (weather.temperature >= 25){
                    head = "Cap"
                    upper = "T-Shirt"
                    lower = "Shorts"
                    boots = "Sneakers"
                } else if (weather.temperature < 25 && weather.temperature >= 20){
                    head = "Cap"
                    upper = "T-Shirt"
                    lower = "Shorts"
                    boots = "Sneakers"
                } else if (weather.temperature < 20 && weather.temperature >= 15){
                    upper = "Hoodie"
                    lower = "Shorts"
                    boots = "Sneakers"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Hoodie"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature < 15 && weather.temperature >= 10){
                    upper = "Hoodie"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature < 10 && weather.temperature >= 0){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "WindBreaker"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature < 0 && weather.temperature >= -10){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature < -10 && weather.temperature >= -20){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature < -20){
                    head = "Insulated Hat"
                    upper = "Insulated Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                }
            }
            if (weather.weatherCondition == "дождь"){
                upper = "WindBreaker"
                subUpper = "На улице дождь"
                lower = "Pants"
            } else if (weather.weatherCondition == "легкий дождь"){
                upper = "Hoodie"
            }
        }
        else if(gender == true){
            if (weather.windSpeed < 5 && weather.windSpeed >= 0){
                if (weather.temperature >= 25){
                    head = "Шляпа"
                    upper = "T-Shirt"
                    lower = "Skirt"
                    boots = "Sneakers"
                } else if (weather.temperature >= 20 && weather.temperature < 25){
                    head = "Шляпа"
                    upper = "T-Shirt"
                    lower = "Skirt"
                    boots = "Sneakers"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Hoodie"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature >= 10 && weather.temperature < 15){
                    upper = "WindBreaker"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature >= 0 && weather.temperature < 10){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "Jacket"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature >= -10 && weather.temperature < 0){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants + трикоши"
                    boots = "Winter Shoes"
                } else if (weather.temperature >= -20 && weather.temperature < -10){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie и перчатки"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature < -20){
                    head = "Insulated Hat"
                    upper = "Insulated Jacket"
                    subUpper = "А еще теплая Hoodie и перчатки"
                    lower = "Pants"
                    boots = "Winter Shoes"
                }
            } else if (weather.windSpeed >= 5){
                if (weather.temperature >= 25){
                    head = "Шляпа"
                    upper = "T-Shirt"
                    lower = "Skirt"
                    boots = "Sneakers"
                } else if (weather.temperature < 25 && weather.temperature >= 20){
                    head = "Шляпа"
                    upper = "T-Shirt"
                    lower = "Skirt"
                    boots = "Sneakers"
                } else if (weather.temperature < 20 && weather.temperature >= 15){
                    upper = "Hoodie"
                    lower = "Dress"
                    boots = "Sneakers"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Hoodie"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature < 15 && weather.temperature >= 10){
                    upper = "Hoodie"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature < 10 && weather.temperature >= 0){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "WindBreaker"
                    lower = "Pants"
                    boots = "Sneakers"
                } else if (weather.temperature < 0 && weather.temperature >= -10){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature < -10 && weather.temperature >= -20){
                    head = "Hat"
                    upper = "Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                } else if (weather.temperature < -20){
                    head = "Insulated Hat"
                    upper = "Insulated Jacket"
                    subUpper = "А еще теплая Hoodie"
                    lower = "Pants"
                    boots = "Winter Shoes"
                }
            }
            if (weather.weatherCondition == "дождь"){
                upper = "Jacket"
                subUpper = "На улице дождь"
                lower = "Pants"
            } else if (weather.weatherCondition == "легкий дождь"){
                upper = "Hoodie"
            }
        }
    }*/
    
    func generateImage(value: String) -> UIImage?{
        let val = value.removingWhitespaces()
        if(gender == false){
            if(val != ""){
                guard val != "Hoodie" else {
                    return UIImage.init(named: (String(format: "%@_%@", "WindBreaker", "м")))!
                }
                print(val)
                let image = UIImage.init(named: (String(format: "%@_%@", val, "м")))!
                return image
            }
            else{
                return nil
            }
        }
        else{
            if(val != ""){
                guard val != "Hoodie" else {
                    return UIImage.init(named: (String(format: "%@_%@", "WindBreaker", "ж")))!
                }
                let image = UIImage.init(named: (String(format: "%@_%@", val, "ж")))!
                return image
            }
            else{
                return nil
            }
        }
    }
    
    func getClothes(weather: Weather, inventory: Inventory, section : Int, value: String) -> Array<Any>{
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
                    clothesDict.append(setDictWithImage(value: value))
                }
            }
        }
        else{
            if(value != ""){
                clothesDict.append(setDictWithImage(value: value))
            }
        }
        return clothesDict
    }
    
    func setDictWithImage(value: String) -> Dictionary<String, Any>{
        let image = generateImage(value: value)!
        var clothe = Dictionary<String, Any>()
        clothe["image"] = image
        return clothe
    }
    
    func generateClothes(weather : Weather){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "gender") as? NSData {
            gender = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
        }
        
        guard (weather.humidity != 0) else {
            return
        }
        let temperature = Double(9/5 * Double(weather.temperature) + 32)
        print(temperature)
        let wind = 2.23694 * Double(weather.windSpeed)
        print(wind)
        if(wind != 0){
            let velocity = pow(wind, 0.16)
            chill = (35.74 + (0.6215 * temperature) - (35.75 * velocity) + (0.4275 * temperature * velocity) - 32) * 5/9
            print(chill)
        }
        else{
            chill = temperature
        }
        
        if(chill < -30){
            head = "Insulated Hat"
            upper = "Insulated Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill >= -30 && chill <= -25){
            head = "Insulated Hat"
            upper = "Insulated Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill > -25 && chill <= -20){
            head = "Insulated Hat"
            upper = "Insulated Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill > -20 && chill <= -15){
            head = "Hat"
            upper = "Insulated Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill > -15 && chill <= -10){
            head = "Hat"
            upper = "Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill > -10 && chill <= -5){
            head = "Hat"
            upper = "Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill > -5 && chill <= 0){
            head = "Hat"
            upper = "Jacket"
            lower = "Pants"
            boots = "Winter Shoes"
        }
        else if(chill > 0 && chill <= 5){
            upper = "Jacket"
            lower = "Pants"
            boots = "Sneakers"
        }
        else if(chill > 5 && chill <= 10){
            upper = "WindBreaker"
            lower = "Pants"
            boots = "Sneakers"
        }
        else if(chill > 10 && chill <= 15){
            upper = "WindBreaker"
            lower = "Pants"
            boots = "Sneakers"
        }
        else if(chill > 15 && chill <= 20){
            upper = "Hoodie"
            lower = "Pants"
            boots = "Sneakers"
        }
        else if(chill > 20 && chill <= 25){
            head = "Cap"
            upper = "T-Shirt"
            lower = gender ? "Skirt" : "Shorts"
            boots = "Sneakers"
        }
        else if(chill > 25 && chill <= 30){
            head = "Cap"
            upper = "T-Shirt"
            lower = gender ? "Skirt" : "Shorts"
            boots = "Sneakers"
        }
        else if(chill > 30){
            head = "Cap"
            upper = "T-Shirt"
            lower = gender ? "Skirt": "Shorts"
            boots = "Slippers"
        }
    }
    
    func getNameForIndex(index : Int) -> String{
        switch index {
        case 0:
            return head
        case 1:
            return upper
        case 2:
            return lower
        case 3:
            return boots
        default:
            return ""
        }
    }
    
    func getDescriptionForIndex(index : Int) -> String{
        switch index {
        case 0:
            return headDescription
        case 1:
            return upperDescription
        case 2:
            return lowerDescription
        case 3:
            return bootsDescription
        default:
            return ""
        }
    }

}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
