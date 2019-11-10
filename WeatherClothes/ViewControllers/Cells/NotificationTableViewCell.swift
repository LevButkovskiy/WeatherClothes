//
//  NotificationTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 10.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet var switcher: UISwitch!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var warningLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLabel.text = "notificationsTitle".localized
        descriptionLabel.text = "notificationsDescription".localized
        warningLabel.text = "notificationsWarning".localized
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
            descriptionLabel.textColor = .lightGray
            warningLabel.textColor = .darkGray
        }
        else{
            backgroundColor = .white
            titleLabel.textColor = .black
            descriptionLabel.textColor = .darkGray
            warningLabel.textColor = .lightGray
        }
    }
}
