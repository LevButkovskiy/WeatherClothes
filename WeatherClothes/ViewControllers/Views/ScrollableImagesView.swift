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
    
    var height = CGFloat()
    var scrollViewPosition = CGFloat()
    var index = Int()
    var clothesImageViews = Array<UIImageView>()
    var imageViews = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func getImageWithIndex() -> UIImage{
        let image = imageViews[index].image
        return image!
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
    
    func setImages(clothesImageViews: Array<UIImageView>){
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
            contentView.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            scrollView.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
        else{
            contentView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            scrollView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        }
    }
    
    private func setupImages(){
        imageViews = [UIImageView]()
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
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        for(index, imageView) in imageViews.enumerated(){
            imageView.frame.size = CGSize(width: height, height: height)
            imageView.frame.origin.x = height * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth  = height * CGFloat(imageViews.count)
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
        if(scrollViewPosition <= scrollView.contentSize.width - height * 2){
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
