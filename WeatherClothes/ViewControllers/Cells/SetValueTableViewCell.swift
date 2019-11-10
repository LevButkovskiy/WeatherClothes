//
//  SetValueTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class SetValueTableViewCell: UITableViewCell {
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "time".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            titleLabel.textColor = .white
            valueLabel.textColor = .lightGray
        }
        else{
            backgroundColor = .white
            titleLabel.textColor = .black
            valueLabel.textColor = .darkGray
        }
    }
    
}
