//
//  TimePickerTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class TimePickerTableViewCell: UITableViewCell {
    @IBOutlet var timePicker: UIDatePicker!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
