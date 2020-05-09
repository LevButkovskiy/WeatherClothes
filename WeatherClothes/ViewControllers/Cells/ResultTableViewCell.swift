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
    var clothesImageViews = Array<Clothe>()
    private var imageViews = [DoubleImageViewsView]()
    
    var appearance = Appearance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = nil
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
        
        for (index, clothe) in clothesImageViews.enumerated(){
            let doubleView = DoubleImageViewsView()
            doubleView.setImages(imageNamed: clothe.imageName, color: clothe.color)
            doubleView.setTheme()
            doubleView.frame.size = CGSize(width: height, height: height)
            doubleView.frame.origin.x = height * CGFloat(index)
            doubleView.frame.origin.y = 0

            scrollView.addSubview(doubleView)
            imageViews.append(doubleView)
        }
        
        let contentWidth  = height * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: height)
 
    }

}
