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
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        }
        else{
            backgroundColor = .white
            timePicker.setValue(UIColor.black, forKeyPath: "textColor")
        }
    }
    
}
