//
//  Settings.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 04/10/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class Settings: NSObject {
    var theme = Bool()
    func isConnectedToNetwork() -> Bool{
        if Reachability.isConnectedToNetwork(){
            //Internet Connection Available
            return true
        }else{
            //Internet Connection not Available
            return false
        }
    }
    override init() {
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            self.theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
        }
    }
    
    static func shared() -> Settings {
        return Settings()
    }
    
    static func themeChanged(theme: Bool){
        do{
            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: theme, requiringSecureCoding: true)
            UserDefaults().set(archivedObject, forKey: "theme")
            //setTheme(!switcher.isOn)
        }
        catch {
            print(error)
        }
    }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

extension String {
    func capitalizedFirst() -> String {
        if(self.count > 0){
            let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
            let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
            return first.uppercased() + rest.lowercased()
        }
        else{
            return self
        }
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIImage
{
    // convenience function in UIImage extension to resize a given image
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage
    {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copied!
    }
}

extension UIColor {
    var name: String? {
        switch self {
        case UIColor.black: return "black"
        case UIColor.darkGray: return "darkGray"
        case UIColor.lightGray: return "lightGray"
        case UIColor.white: return "white"
        case UIColor.gray: return "gray"
        case UIColor.red: return "red"
        case UIColor.green: return "green"
        case UIColor.blue: return "blue"
        case UIColor.cyan: return "cyan"
        case UIColor.yellow: return "yellow"
        case UIColor.magenta: return "magenta"
        case UIColor.orange: return "orange"
        case UIColor.purple: return "purple"
        case UIColor.brown: return "brown"
        default: return nil
        }
    }
    
    func themeColor(referense: Bool) -> UIColor{
        if(!referense){
            switch self {
            case .white:
                return UIColor(red:0.12, green:0.12, blue:0.12, alpha:1.0)
            case .black:
                return .white
            default:
                return .black
            }
        }
        else{
            return self
        }
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
