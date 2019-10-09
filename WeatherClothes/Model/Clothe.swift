//
//  Clothe.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 09/10/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class Clothe: NSObject {

    var name : String
    var image : Data
    var color : UIColor
    var comfortTemperature : Int?
    var comfortWind : Int?
    var type : Int!
    
    init(name : String, image: Data, type: Int, color: UIColor, comfortTemperature: Int, comfortWind: Int) {
        self.name = ""
        self.image = image
        self.color = .white
        self.comfortTemperature = nil
        self.comfortWind = nil
        self.type = nil
    }
}
