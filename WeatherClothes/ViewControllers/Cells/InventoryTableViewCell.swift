//
//  InventoryTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 06/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var clotheName: UILabel!
    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var windProtection: UILabel!
    @IBOutlet weak var comfortableTemperature: UILabel!
    @IBOutlet weak var clotheView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        clotheImage.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkTheme()
        // Configure the view for the selected state
    }
    
    func checkTheme(){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
            if(theme){
                setDarkTheme()
            }
            else{
                setLightTheme()
            }
        }
    }
    
    func setDarkTheme(){
        backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        clotheView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        descriptionView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        clotheName.textColor = .white
    }
    
    func setLightTheme(){
        backgroundColor = .groupTableViewBackground
        clotheView.backgroundColor = .groupTableViewBackground
        descriptionView.backgroundColor = . groupTableViewBackground

        clotheName.textColor = .black
    }
    
}
