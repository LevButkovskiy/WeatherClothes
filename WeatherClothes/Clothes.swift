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
    var subHead = String()
    var upper = String()
    var subUpper = String()
    var lower = String()
    var boots = String()
    var gender = Bool()
    
    func generateClothes(weather : Weather){
        if(gender == false){
            if (weather.windSpeed < 5 && weather.windSpeed >= 0){
                if (weather.temperature >= 25){
                    head = "Кепка"
                    upper = "Футболка"
                    lower = "Шорты"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 20 && weather.temperature < 25){
                    head = "Кепка"
                    upper = "Футболка"
                    lower = "Шорты"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Кофта"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 10 && weather.temperature < 15){
                    upper = "Ветровка"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 0 && weather.temperature < 10){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "Куртка"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature >= -10 && weather.temperature < 0){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature >= -20 && weather.temperature < -10){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта и перчатки"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature > -20){
                    head = "Утепленная шапка"
                    upper = "Утепленная куртка"
                    subUpper = "А еще теплая кофта и перчатки"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                }
            } else if (weather.windSpeed >= 5){
                if (weather.temperature >= 25){
                    head = "Кепка"
                    upper = "Футболка"
                    lower = "Шорты"
                    boots = "Кроссовки"
                } else if (weather.temperature < 25 && weather.temperature >= 20){
                    head = "Кепка"
                    upper = "Футболка"
                    lower = "Шорты"
                    boots = "Кроссовки"
                } else if (weather.temperature < 20 && weather.temperature >= 15){
                    upper = "Кофта"
                    lower = "Шорты"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Кофта"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature < 15 && weather.temperature >= 10){
                    upper = "Кофта"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature < 10 && weather.temperature >= 0){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "Ветровка"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature < 0 && weather.temperature >= -10){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature < -10 && weather.temperature >= -20){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature > -20){
                    head = "Утепленная шапка"
                    upper = "Утепленная куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                }
            }
            if (weather.weatherCondition == "дождь"){
                upper = "Ветровка"
                subUpper = "На улице дождь"
                lower = "Штаны"
            } else if (weather.weatherCondition == "легкий дождь"){
                upper = "Кофта"
            }
        }
        else if(gender == true){
            if (weather.windSpeed < 5 && weather.windSpeed >= 0){
                if (weather.temperature >= 25){
                    head = "Шляпа"
                    upper = "Футболка"
                    lower = "Юбка"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 20 && weather.temperature < 25){
                    head = "Шляпа"
                    upper = "Футболка"
                    lower = "Юбка"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Кофта"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 10 && weather.temperature < 15){
                    upper = "Ветровка"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 0 && weather.temperature < 10){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "Куртка"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature >= -10 && weather.temperature < 0){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны + трикоши"
                    boots = "Зимняя обувь"
                } else if (weather.temperature >= -20 && weather.temperature < -10){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта и перчатки"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature > -20){
                    head = "Утепленная шапка"
                    upper = "Утепленная куртка"
                    subUpper = "А еще теплая кофта и перчатки"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                }
            } else if (weather.windSpeed >= 5){
                if (weather.temperature >= 25){
                    head = "Шляпа"
                    upper = "Футболка"
                    lower = "Юбка"
                    boots = "Кроссовки"
                } else if (weather.temperature < 25 && weather.temperature >= 20){
                    head = "Шляпа"
                    upper = "Футболка"
                    lower = "Юбка"
                    boots = "Кроссовки"
                } else if (weather.temperature < 20 && weather.temperature >= 15){
                    upper = "Кофта"
                    lower = "Платье"
                    boots = "Кроссовки"
                } else if (weather.temperature >= 15 && weather.temperature < 20){
                    upper = "Кофта"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature < 15 && weather.temperature >= 10){
                    upper = "Кофта"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature < 10 && weather.temperature >= 0){
                    subHead = "Возьмите шапку, лишней не будет"
                    upper = "Ветровка"
                    lower = "Штаны"
                    boots = "Кроссовки"
                } else if (weather.temperature < 0 && weather.temperature >= -10){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature < -10 && weather.temperature >= -20){
                    head = "Шапка"
                    upper = "Куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                } else if (weather.temperature > -20){
                    head = "Утепленная шапка"
                    upper = "Утепленная куртка"
                    subUpper = "А еще теплая кофта"
                    lower = "Штаны"
                    boots = "Зимняя обувь"
                }
            }
            if (weather.weatherCondition == "дождь"){
                upper = "Куртка"
                subUpper = "На улице дождь"
                lower = "Штаны"
            } else if (weather.weatherCondition == "легкий дождь"){
                upper = "Кофта"
            }
        }
    }
    
    func generateImage(value: String) -> UIImage?{
        let postfix = gender ? "ж": "м";
        if(value != ""){
            guard value != "Кофта" else {
                return UIImage.init(named: (String(format: "%@_%@", "Ветровка", postfix)))!
            }
            let image = UIImage.init(named: (String(format: "%@_%@", value, postfix)))!
            return image
        }
        else{
            return nil
        }
    }
        
}
