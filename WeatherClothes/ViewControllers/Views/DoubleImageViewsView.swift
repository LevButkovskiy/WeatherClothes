//
//  DoubleImageViewsView.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 09.11.2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class DoubleImageViewsView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var topImageView: UIImageView!

    var appearance = Appearance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("DoubleImageViewsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setTheme()
    }
    
    func setImages(imageNamed: String, color: UIColor){
        self.backImageView.image = UIImage(named: String(format: "%@_white", imageNamed.lowercased()))
        self.backImageView.tintColor = color
        self.topImageView.image = UIImage(named: String(format: "%@_frame", imageNamed.lowercased()))
    }
    
    func setTheme(){
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
    }
}
