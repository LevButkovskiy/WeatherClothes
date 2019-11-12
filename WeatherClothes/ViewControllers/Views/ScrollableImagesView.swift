//
//  ScrollableImagesView.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 14/10/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ScrollableImagesView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var appearance = Appearance()
    
    var height = CGFloat()
    var scrollViewPosition = CGFloat()
    var index = Int()
    var clothesImageViews = Array<Dictionary<String, Any>>()
    var imageViewsBack = [UIImageView]()
    var imageViewsTop = [UIImageView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func getClotheName() -> String{
        let clothe = clothesImageViews[index]
        return clothe["imageName"] as! String
    }
    
    func getClotheColor() -> UIColor{
        let clothe = clothesImageViews[index]
        return clothe["color"] as! UIColor
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("ScrollableImagesView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollViewPosition = 0
        setTheme()
    }
    
    func setImages(clothesImageViews: Array<Dictionary<String, Any>>){
        self.clothesImageViews = clothesImageViews
        setupImages()
        checkButtons()
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            contentView.backgroundColor = appearance.darkThemeBlack
            scrollView.backgroundColor = appearance.darkThemeBlack
        }
        else{
            contentView.backgroundColor = appearance.lightThemeTableViewGray
            scrollView.backgroundColor = appearance.lightThemeTableViewGray
        }
    }
    
    private func setupImages(){
        imageViewsBack = [UIImageView]()
        imageViewsTop = [UIImageView]()
        
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        height = self.frame.height - 80
        scrollView.layer.cornerRadius = 15
        scrollView.layer.shadowColor = UIColor.lightGray.cgColor
        scrollView.layer.shadowOpacity = 1
        scrollView.layer.shadowOffset = .zero
        scrollView.layer.shadowRadius = 3
        
        for imageView in clothesImageViews{
            //imageView.contentMode = .f
            scrollView.addSubview(imageView["back"] as! UIImageView)
            imageViewsBack.append(imageView["back"] as! UIImageView)
            scrollView.addSubview(imageView["top"] as! UIImageView)
            imageViewsTop.append(imageView["top"] as! UIImageView)
        }
        
        for(index, imageView) in imageViewsBack.enumerated(){
            imageView.frame.size = CGSize(width: height, height: height)
            imageView.frame.origin.x = height * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        for(index, imageView) in imageViewsTop.enumerated(){
            imageView.frame.size = CGSize(width: height, height: height)
            imageView.frame.origin.x = height * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth  = height * CGFloat(imageViewsBack.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: height)
    }

    @IBAction func rightButtonClick(_ sender: Any) {
        if(scrollViewPosition <= scrollView.contentSize.width - height){
            scrollViewPosition += height
            index+=1
            checkButtons()
            scrollView.setContentOffset(CGPoint(x: scrollViewPosition, y: 0), animated: true)
        }
    }
    
    @IBAction func leftButtonClick(_ sender: Any) {
        if(scrollViewPosition >= height){
            scrollViewPosition -= height
            index-=1
            checkButtons()
            scrollView.setContentOffset(CGPoint(x: scrollViewPosition, y: 0), animated: true)
        }
    }
    
    private func checkButtons(){
        if(scrollViewPosition >= height){
            leftButton.isEnabled = true
        }
        else{
            leftButton.isEnabled = false
        }
        if(scrollViewPosition <= (scrollView.contentSize.width - height * 2) + 1){
            rightButton.isEnabled = true
        }
        else{
            rightButton.isEnabled = false
        }
    }
    
    func update(toFirst: Bool){
        if(toFirst){
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            scrollViewPosition = 0
            index = 0
            checkButtons()
        }
    }
}
