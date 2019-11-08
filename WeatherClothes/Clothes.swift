//
//  Clothes.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 21/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class Clothes: NSObject {
    

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
    
}
