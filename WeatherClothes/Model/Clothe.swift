//
//  Clothe.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 09/10/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class Clothe: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool{
        return true
    }

    var name : String
    var image : UIImage
    var type : Int!
    var comfortTemperature : Int?
    var comfortWind : Int?
    
    override init() {
        name = ""
        image = UIImage()
        //userImage = Data()
        type = 0
        comfortWind = 0
        comfortTemperature = 0
    }
    
    init(name: String, image: UIImage, type: Int, temperature: Int, wind: Int) {
        self.name = name
        self.image = image
        self.type = type
        self.comfortTemperature = temperature
        self.comfortWind = wind
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        //aCoder.encode(userImage, forKey: "userImage")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(comfortTemperature, forKey: "temperature")
        aCoder.encode(comfortWind, forKey: "wind")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        image = aDecoder.decodeObject(forKey: "image") as! UIImage
        //userImage = aDecoder.decodeObject(forKey: "userImage") as! Data
        type = aDecoder.decodeObject(forKey: "type") as? Int
        comfortTemperature = aDecoder.decodeObject(forKey: "temperature") as? Int
        comfortWind = aDecoder.decodeObject(forKey: "wind") as? Int
    }
}
