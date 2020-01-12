//
//  Inventory.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 27/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

enum Type : Int {
    case head = 0
    case upper = 1
    case lower = 2
    case boots = 3
}

class Inventory: NSObject {

    var inventory = Dictionary<Int, Any>()

    var sections = Array<Int>()
    var gender = Bool()

    var head = String()
    var headDescription = String()
    var upper = String()
    var upperDescription = String()
    var lower = String()
    var lowerDescription = String()
    var boots = String()
    var bootsDescription = String()
    
    override init() {
        super.init()
        if(inventory.isNil()){
            load()
        }
    }
    //MARK: model functions
    func load(){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "inventory") as? NSData {
            inventory = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Dictionary<Int, Any>)
            setSections()
        }
    }
    
    func update(){
        load()
    }
    
    func save(){
        do{
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: inventory, requiringSecureCoding: true)
            UserDefaults().set(archivedObject, forKey: "inventory")
        }
        catch {
            print(error.localizedDescription)
        }
        update()
    }
    
    func add(clothe : Clothe){
        let type = clothe.type!
        if(inventory[type] != nil){
            var itemType = inventory[type] as! Dictionary<Int, Any>
            itemType[itemType.count] = clothe
            inventory[type] = itemType
        }
        else{
            var itemType : Dictionary<Int, Any> = [:]
            itemType[0] = clothe
            inventory[type] = itemType
        }
        save()
    }
    
    func add(name: String, imageName: String, color : UIColor, type: Int, temperature : Int, wind: Int){
        let clothe = Clothe(name: name, imageName: imageName, color: color, type: type, temperature: temperature, wind: wind)
        add(clothe: clothe)
    }
    
    func remove(clothe : Clothe){
        let type = clothe.type!
        var items = inventory[type] as! Dictionary<Int, Any>
        for i in 0..<items.count{
            let invItem = items[i] as! Clothe
            if(invItem.isEqual(clothe)){
                items = deleteAtIndex(dictionary: items, index: i)
                inventory[type] = items
                break;
            }
        }
        if((inventory[type] as! Dictionary<Int, Any>).isNil()){
            inventory.removeValue(forKey: type)
        }
        save()
    }
    
    private func deleteAtIndex(dictionary : Dictionary<Int, Any>, index : Int) -> Dictionary<Int, Any>{
        var dict = dictionary
        if(index != dict.count - 1){
            for j in index..<dict.count - 1{
                dict[j] = dict[j+1]
            }
            dict.removeValue(forKey: dict.count - 1)
            return dict
        }
        else{
            dict.removeValue(forKey: index)
        }
        return dict
    }
    
    func removeAll(){
        for i in 0..<self.inventory.count{
            inventory[i] = nil
        }
        save()
    }
    
    //MARK: TableView functions
    func cellForRowAt(indexPath: IndexPath) -> Clothe?{
        switch sections[indexPath.section] {
        case Type.head.rawValue:
            if(inventory[Type.head.rawValue] != nil){
                let head = inventory[Type.head.rawValue] as! Dictionary<Int, Any>
                return (head[indexPath.row] as! Clothe)
            }
        case Type.upper.rawValue:
            if(inventory[Type.upper.rawValue] != nil){
                let upper = inventory[Type.upper.rawValue] as! Dictionary<Int, Any>
                return (upper[indexPath.row] as! Clothe)
            }
        case Type.lower.rawValue:
            if(inventory[Type.lower.rawValue] != nil){
                let lower = inventory[Type.lower.rawValue] as! Dictionary<Int, Any>
                return (lower[indexPath.row] as! Clothe)
            }
        case Type.boots.rawValue:
            if(inventory[Type.boots.rawValue] != nil){
                let boots = inventory[Type.boots.rawValue] as! Dictionary<Int, Any>
                return (boots[indexPath.row] as! Clothe)
            }
        default:
            return nil
        }
        return nil
    }
    
    func numberOfSections() -> Int{
        return sections.count
    }
    
    func numberOfRowsInSection(section : Int) -> Int{
        switch sections[section] {
        case Type.head.rawValue:
            if(inventory[Type.head.rawValue] != nil){
                let head = inventory[Type.head.rawValue] as! Dictionary<Int, Any>
                return head.count
            }
        case Type.upper.rawValue:
            if(inventory[Type.upper.rawValue] != nil){
                let upper = inventory[Type.upper.rawValue] as! Dictionary<Int, Any>
                return upper.count
            }
        case Type.lower.rawValue:
            if(inventory[Type.lower.rawValue] != nil){
                let lower = inventory[Type.lower.rawValue] as! Dictionary<Int, Any>
                return lower.count
            }
        case Type.boots.rawValue:
            if(inventory[Type.boots.rawValue] != nil){
                let boots = inventory[Type.boots.rawValue] as! Dictionary<Int, Any>
                return boots.count
            }
        default:
            return 1
        }
        return 1
    }
    
    func titleForHeaderInSection(section: Int) -> String{
        return stringValueOfType(type: sections[section])
    }
    
    func setSections(){
        sections = []
        if(inventory[Type.head.rawValue] != nil){
            let head = inventory[Type.head.rawValue] as! Dictionary<Int, Any>
            if(head.count > 0){
                if(!sections.contains(Type.head.rawValue)){
                    sections.append(Type.head.rawValue)
                }
            }
        }
        if(inventory[Type.upper.rawValue] != nil){
            let upper = inventory[Type.upper.rawValue] as! Dictionary<Int, Any>
            if(upper.count > 0){
                if(!sections.contains(Type.upper.rawValue)){
                    sections.append(Type.upper.rawValue)
                }
            }
        }
        if(inventory[Type.lower.rawValue] != nil){
            let lower = inventory[Type.lower.rawValue] as! Dictionary<Int, Any>
            if(lower.count > 0){
                if(!sections.contains(Type.lower.rawValue)){
                    sections.append(Type.lower.rawValue)
                }
            }
        }
        if(inventory[Type.boots.rawValue] != nil){
            let boots = inventory[Type.boots.rawValue] as! Dictionary<Int, Any>
            if(boots.count > 0){
                if(!sections.contains(Type.boots.rawValue)){
                    sections.append(Type.boots.rawValue)
                }
            }
        }
    }
    
    //Clothes methods
    func generateClothes(weather : Weather){
        var chill = Double()
        gender = Settings.shared().gender
        
        guard (weather.humidity != 0) else {
            return
        }
        let temperature = Double(9/5 * Double(weather.temperature) + 32)
        let wind = 2.23694 * Double(weather.windSpeed)
        if(wind == 0.0){
            chill = Double(weather.temperature)
        }
        else{
            let velocity = pow(wind, 0.16)
            chill = (35.74 + (0.6215 * temperature) - (35.75 * velocity) + (0.4275 * temperature * velocity) - 32) * 5/9
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
            head = "Hat"
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
            head = gender ? "Cap_w" : "Cap_m"
            upper = "TShirt"
            lower = gender ? "Skirt" : "Shorts"
            boots = "Sneakers"
        }
        else if(chill > 25 && chill <= 30){
            head = gender ? "Cap_w" : "Cap_m"
            upper = "TShirt"
            lower = gender ? "Skirt" : "Shorts"
            boots = "Sneakers"
        }
        else if(chill > 30){
            head = gender ? "Cap_w" : "Cap_m"
            upper = "TShirt"
            lower = gender ? "Skirt": "Shorts"
            boots = "Slippers"
        }
    }
    
    /*func getClothes(weather: Weather, section : Int, value: String) -> Array<Dictionary<String,Any>>{
        if(!weather.isNull){
            var clothesDict = Array<Dictionary<String,Any>>()
            if(inventory[section] != nil){
                let typeOfClothe = inventory[section] as! Dictionary<Int, Any>
                for i in 0..<typeOfClothe.count{
                    let clothe = typeOfClothe[i] as! Clothe
                    if(weather.temperature >= clothe.comfortTemperature! && weather.windSpeed <= clothe.comfortWind!){
                        clothesDict.append(generateImage(imageName: clothe.imageName, color: clothe.color))
                    }
                }
                if(clothesDict.count == 0){
                    print(value)
                    if(value != ""){
                        clothesDict.append(generateImage(imageName: value, color: .white))
                    }
                }
            }
            else{
                if(value != ""){
                    clothesDict.append(generateImage(imageName: value, color: .white))
                }
            }
            return clothesDict
        }
        else{
            return []
        }
    }*/
    
    func getClothes(weather: Weather, section : Int, value: String) -> Array<Clothe>{
        if(!weather.isNull){
            var clothesDict = Array<Clothe>()
            if(inventory[section] != nil){
                let typeOfClothe = inventory[section] as! Dictionary<Int, Any>
                for i in 0..<typeOfClothe.count{
                    let clothe = typeOfClothe[i] as! Clothe
                    if(weather.temperature >= clothe.comfortTemperature! && weather.windSpeed <= clothe.comfortWind!){
                        clothesDict.append(clothe)
                    }
                }
                if(clothesDict.count == 0){
                    print(value)
                    if(value != ""){
                        let clothe = Clothe(imageName: value, color: .white)
                        clothesDict.append(clothe)
                    }
                }
            }
            else{
                if(value != ""){
                    let clothe = Clothe(imageName: value, color: .white)
                    clothesDict.append(clothe)
                }
            }
            return clothesDict
        }
        else{
            return []
        }
    }
    /*
    func setClotheWithImage(value: String) -> Dictionary<String,Any>{
        return generateImage(imageName: value, color: nil)
        //clothe.image = generateImage(value: value)!
    }
    
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
    
    func generateImage(value: String) -> String{
        let val = value.removingWhitespaces()
        if(gender == false){
            if(val != ""){
                guard val != "Hoodie" else {
                    return String(format: "%@_%@", "WindBreaker", "м")
                }
                print(val)
                let image = String(format: "%@_%@", val, "м")
                return image
            }
            else{
                return ""
            }
        }
        else{
            if(val != ""){
                guard val != "Hoodie" else {
                    return String(format: "%@_%@", "WindBreaker", "ж")
                }
                let image = String(format: "%@_%@", val, "ж")
                return image
            }
            else{
                return ""
            }
        }
    }
    */
    //Index methods
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
    
    func stringValueOfType(type : Int) -> String{
        switch type {
        case Type.head.rawValue:
            return "Hats".localized
        case Type.upper.rawValue:
            return "TopOfClothes".localized
        case Type.lower.rawValue:
            return "LowerPartOfClothes".localized
        case Type.boots.rawValue:
            return "Footwear".localized
        default:
            return ""
        }
    }
    
    func generateImage(imageName: String, color: UIColor) -> Dictionary<String, Any> {
        var result = Dictionary<String,Any>()
        let backImage = UIImage(named: String(format: "%@_white", imageName.lowercased().removingWhitespaces()))
        let topImage = UIImage(named: String(format: "%@_frame", imageName.lowercased().removingWhitespaces()))
        let backImageView = UIImageView(image: backImage)
        let topImageView = UIImageView(image: topImage)
        backImageView.tintColor = color
        result["back"] = backImageView
        result["top"] = topImageView
        result["imageName"] = imageName
        result["color"] = color
        return result
    }

}
