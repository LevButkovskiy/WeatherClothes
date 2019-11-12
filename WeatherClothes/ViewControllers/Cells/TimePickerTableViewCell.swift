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
    
    var appearance = Appearance()

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
            backgroundColor = appearance.darkThemeGray
            timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        }
        else{
            backgroundColor = .white
            timePicker.setValue(UIColor.black, forKeyPath: "textColor")
        }
    }
    
}
