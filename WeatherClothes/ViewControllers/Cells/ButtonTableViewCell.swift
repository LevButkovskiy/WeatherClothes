//
//  ButtonTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    @IBOutlet var button: UIButton!
    
    var appearance = Appearance()

    override func awakeFromNib() {
        super.awakeFromNib()
        button.backgroundColor = .whatsNewKitGreen
        button.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        button.setTitle("establish".localized, for: .normal)
        // Configure the view for the selected state
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            backgroundColor = appearance.darkThemeGray
        }
        else{
            backgroundColor = .white
        }
    }
    
}
