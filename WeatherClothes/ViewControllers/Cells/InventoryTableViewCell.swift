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
    @IBOutlet weak var clotheImage: DoubleImageViewsView!
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
        //checkTheme()
        // Configure the view for the selected state
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            clotheView.backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            descriptionView.backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            clotheName.textColor = .white
            windProtection.textColor = .white
            comfortableTemperature.textColor = .white
        }
        else{
            backgroundColor = .white
            clotheView.backgroundColor = .white
            descriptionView.backgroundColor = .white
            clotheName.textColor = .black
            windProtection.textColor = .black
            comfortableTemperature.textColor = .black
        }
    }
    
}
