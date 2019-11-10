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

    override func awakeFromNib() {
        super.awakeFromNib()
        button.backgroundColor = .whatsNewKitGreen
        button.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
