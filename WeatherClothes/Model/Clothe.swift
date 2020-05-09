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
    var imageName : String
    var color : UIColor
    var type : Int!
    var comfortTemperature : Int?
    var comfortWind : Int?
    
    override init() {
        name = ""
        imageName = ""
        color = .white
        //userImage = Data()
        type = 0
        comfortWind = 0
        comfortTemperature = 0
    }
    
    init(name: String, imageName : String, color: UIColor, type: Int, temperature: Int, wind: Int) {
        self.name = name
        self.imageName = imageName
        self.color = color
        self.type = type
        self.comfortTemperature = temperature
        self.comfortWind = wind
    }
    
    init(imageName : String, color: UIColor) {
        self.imageName = imageName
        self.color = color
        self.name = ""
        self.type = 0
        self.comfortTemperature = 0
        self.comfortWind = 0;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageName, forKey: "imageName")
        let colorData = color.encode()
        aCoder.encode(colorData, forKey: "color")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(comfortTemperature, forKey: "temperature")
        aCoder.encode(comfortWind, forKey: "wind")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        imageName = aDecoder.decodeObject(forKey: "imageName") as! String
        let colorData = aDecoder.decodeObject(forKey: "color") as! Data
        color = UIColor.color(withData: colorData)
        type = aDecoder.decodeObject(forKey: "type") as? Int
        comfortTemperature = aDecoder.decodeObject(forKey: "temperature") as? Int
        comfortWind = aDecoder.decodeObject(forKey: "wind") as? Int
    }
}

extension UIColor {
    class func color(withData data:Data) -> UIColor {
         return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }

    func encode() -> Data {
         return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
