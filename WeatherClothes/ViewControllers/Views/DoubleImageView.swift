//
//  DoubleImageView.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 30.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
var backImageView: UIImageView!
var topImageView: UIImageView!

class DoubleImageView: UIImageView {


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setImages(backImageView : UIImageView, topImageView: UIImageView){
        let imageView = backImageView
        self.image = imageView.image
        self.tintColor = imageView.tintColor
        //self.image = UIImage(named: "updates")
        //self.topImageView.image = topImageView.image
    }
    
    func setImages(imageView : Dictionary<String, Any>){
        if(imageView["top"] != nil){
            let image = UIImageView()
            image.image = UIImage(named: "tshirt_white")
            //let imageViews = imageView["top"] as! UIImageView
            self.image = image.image!
        }
        //self.tintColor = imageViews.tintColor
        //self.image = UIImage(named: "updates")
        //self.topImageView.image = topImageView.image
    }
    
    /*func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            self.contentView.backgroundColor = appearance.darkThemeGray
        }
        else{
            self.contentView.backgroundColor = .white
        }
    }*/
}
