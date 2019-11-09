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
        //setTheme()
    }
    
    func setImages(backImageView : UIImageView, topImageView: UIImageView){
        self.backImageView.image = backImageView.image
        self.backImageView.tintColor = backImageView.tintColor
        self.topImageView.image = topImageView.image
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            self.contentView.backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        }
        else{
            self.contentView.backgroundColor = .white
        }
    }
}
