//
//  Appearance.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 12.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
class Appearance: NSObject {
    
    override init() {
    }
    var lightThemeTableViewGray : UIColor{
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    var darkThemeBlue : UIColor{
        return UIColor(red: 30.0/255.0, green: 32.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    }
    
    var darkThemeGray : UIColor{
        return UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    }
    
    var darkThemeBlack : UIColor{
        return UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    func showCompleteViewWithRemovingAllViews(view : UIView, text: String){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = view.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        
        let backView = UIView()
        let completeView = UIImageView()
        let label = UILabel()
        completeView.frame = CGRect(x: view.frame.width / 2 - 75, y: view.frame.height / 2 - 75, width: 150, height: 150)
        backView.frame = CGRect(x: completeView.frame.minX - completeView.frame.width / 2, y: completeView.frame.minY - completeView.frame.height / 2, width: completeView.frame.width * 2, height: completeView.frame.height * 2)
        label.frame = CGRect(x: 0, y: completeView.frame.maxY, width: view.frame.width, height: 50)

        backView.layer.cornerRadius = backView.frame.width / 2
        backView.backgroundColor = theme ? self.lightThemeTableViewGray : self.darkThemeBlue
        label.textColor = theme ? .black : .white
        label.textAlignment = .center
        
        label.text = text
        completeView.image = UIImage(named: "completeIcon")
        
        backView.alpha = 0
        completeView.alpha = 0
        label.alpha = 0

        view.addSubview(backView)
        view.addSubview(completeView)
        view.addSubview(label)
        UIView.animate(withDuration: 0.5, animations: {
            backView.alpha = 0.75
            completeView.alpha = 1
            label.alpha = 1
        }) { (completion) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                UIView.animate(withDuration: 0.5, animations: {
                    backView.alpha = 0
                    completeView.alpha = 0
                    label.alpha = 0
                }) { (completion) in
                    backView.removeFromSuperview()
                    completeView.removeFromSuperview()
                    label.removeFromSuperview()
                }
            }
        }
    }
}
