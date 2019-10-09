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
    var usedSections = Array<Int>()
    
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
            print(error)
        }
        update()
    }
    
    func add(clothe : Clothe){
        let type = clothe.type as! Int
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
    
    func add(name: String, image : UIImage, type: Int, temperature : Int, wind: Int){
        let clothe = Clothe(name: name, image: image.jpegData(compressionQuality: 0.1)!, type: type, color: .white, comfortTemperature: temperature, comfortWind: wind)
        add(clothe: clothe)
        /*var item = Dictionary<String, Any>()
        item["name"] = name
        item["image"] = image.jpegData(compressionQuality: 0.1)
        item["type"] = type
        item["temperature"] = temperature
        item["wind"] = wind
        add(item: item)*/
    }
    
    func remove(clothe : Clothe){
        let type = clothe.type as! Int
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
                return head[indexPath.row] as! Clothe
            }
        case Type.upper.rawValue:
            if(inventory[Type.upper.rawValue] != nil){
                let upper = inventory[Type.upper.rawValue] as! Dictionary<Int, Any>
                return upper[indexPath.row] as! Clothe
            }
        case Type.lower.rawValue:
            if(inventory[Type.lower.rawValue] != nil){
                let lower = inventory[Type.lower.rawValue] as! Dictionary<Int, Any>
                return lower[indexPath.row] as! Clothe
            }
        case Type.boots.rawValue:
            if(inventory[Type.boots.rawValue] != nil){
                let boots = inventory[Type.boots.rawValue] as! Dictionary<Int, Any>
                return boots[indexPath.row] as! Clothe
            }
        default:
            return nil
        }
        return nil
    }
    
    func titleForHeaderInSection(section: Int) -> String{
        return stringValueOfType(type: sections[section])
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
            return 0
        }
        return 0
    }
    
    func numberOfSections() -> Int{
        return sections.count
    }
    
    //MARK: Default functions
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
    func stringValueOfType(type : Int) -> String{
        switch type {
        case Type.head.rawValue:
            return "Головные уборы"
        case Type.upper.rawValue:
            return "Верхняя часть одежды"
        case Type.lower.rawValue:
            return "Нижняя часть одежды"
        case Type.boots.rawValue:
            return "Обувь"
        default:
            return ""
        }
    }
    
    func tmpStringValueOfType(type : Int) -> String{
        switch type {
        case Type.head.rawValue:
            return "cap"
        case Type.upper.rawValue:
            return "tshirt"
        case Type.lower.rawValue:
            return "pants"
        case Type.boots.rawValue:
            return "sneakers"
        default:
            return ""
        }
    }
    
    func getIndexForTypeName(type : String) ->Int{
        switch type {
        case "Головной убор":
            return 0
        case "Верхняя часть одежды":
            return 1
        case "Нижняя часть одежды":
            return 2
        case "Обувь":
            return 3
        default:
            return 0
        }
    }
    
    func getTypeNameFromIndex(index : Int) -> String{
        switch index {
        case 0:
            return "Головной убор"
        case 1:
            return "Верхняя часть одежды"
        case 2:
            return "Нижняя часть одежды"
        case 3:
            return "Обувь"
        default:
            return ""
        }
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
}

extension Dictionary{
    // Only for Int and String
    func isEqual(dict : Dictionary) -> Bool{
        let keys = dict.keys
        for key in keys{
            if(self[key] as? String != nil){
                let first = self[key] as? String
                let second = dict[key] as? String
                if(first != second){
                    return false
                }
            }
            else if(self[key] as? Int != nil){
                let first = self[key] as? Int
                let second = dict[key] as? Int
                if(first != second){
                    return false
                }
            }
        }
        return true
    }
    
    func isNil() -> Bool{
        if(self.count == 0){
            return true;
        }
        let keys = self.keys
        if(keys.count == 0){
            return true
        }
        for key in keys{
            if(self[key] == nil){
                return true
            }
        }
        return false
    }
}

/*
func deleteClothe(delClothe : Dictionary<String, Any>){
    for i in 0 ..< inventory.count{
        var type = inventory[i] as! Dictionary<Int, Any>
        for j in 0 ..< type.count{
            let clothe = type[j] as! Dictionary<String, Any>
            if(clothe.isEqual(dict: delClothe)){
                type = deleteItemWithReplasing(dictionary: type, index: j)
                inventory[i] = type
                if(type.count == 0){
                    inventory = deleteItemWithReplasing(dictionary: inventory, index: i)
                }
                tableView.reloadData()
                saveClothe()
                return
            }
        }
    }
}*/
