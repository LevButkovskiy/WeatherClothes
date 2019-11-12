//
//  ResultTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 08/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var clotheName: UILabel!
    @IBOutlet weak var clotheDescription: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    
    var height = CGFloat()
    var clothesImageViews = Array<Dictionary<String,Any>>()
    private var imageViews = [DoubleImageViewsView]()
    
    var appearance = Appearance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = nil

        if(UIScreen.main.nativeBounds.height != 1136){
            /*windView.layer.cornerRadius = 10
            windView.layer.shadowColor = UIColor.lightGray.cgColor
            windView.layer.shadowOpacity = 0.5
            windView.layer.shadowOffset = .init(width: 2, height: 2)
            tempView.layer.cornerRadius = 10
            tempView.layer.shadowColor = UIColor.lightGray.cgColor
            tempView.layer.shadowOpacity = 0.5
            tempView.layer.shadowOffset = .init(width: 2, height: 2)
            comfortView.layer.cornerRadius = 10
            comfortView.layer.shadowColor = UIColor.lightGray.cgColor
            comfortView.layer.shadowOpacity = 0.5
            comfortView.layer.shadowOffset = .init(width: 2, height: 2)*/
        }
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            clotheName.textColor = .white
            backView.backgroundColor = appearance.darkThemeGray
            scrollView.backgroundColor = appearance.darkThemeGray

        }
        else{
            clotheName.textColor = .black
            backView.backgroundColor = .white
            scrollView.backgroundColor = .white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImages(){
        imageViews = [DoubleImageViewsView]()
        
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        height = self.frame.height - 20
        scrollView.layer.cornerRadius = 15
        scrollView.layer.shadowColor = UIColor.lightGray.cgColor
        scrollView.layer.shadowOpacity = 1
        scrollView.layer.shadowOffset = .zero
        scrollView.layer.shadowRadius = 3
        
        for imageView in clothesImageViews{
            //imageView.contentMode = .f
            let doubleView = DoubleImageViewsView()
            doubleView.setImages(backImageView: imageView["back"] as! UIImageView, topImageView: imageView["top"] as! UIImageView)
            doubleView.setTheme()
            scrollView.addSubview(doubleView)
            imageViews.append(doubleView)
        }
        
        for(index, imageView) in imageViews.enumerated(){
            imageView.frame.size = CGSize(width: height, height: height)
            imageView.frame.origin.x = height * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        
        let contentWidth  = height * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: height)
    }

}
