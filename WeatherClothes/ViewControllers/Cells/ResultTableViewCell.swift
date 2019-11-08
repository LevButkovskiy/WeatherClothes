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
    
    var height = CGFloat()
    var clothesImages = Array<Any>()
    var imageViews = [UIImageView]()
    
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
        let settings = Settings()
        let theme = settings.theme
        if(theme){
            clotheName.textColor = .white
        }
        else{
            clotheName.textColor = .black
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImages(){
        imageViews = [UIImageView]()
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        height = self.frame.height - 20
        scrollView.layer.cornerRadius = 15
        scrollView.layer.shadowColor = UIColor.lightGray.cgColor
        scrollView.layer.shadowOpacity = 1
        scrollView.layer.shadowOffset = .zero
        scrollView.layer.shadowRadius = 3
        scrollView.backgroundColor = nil
        
        if(clothesImages.count == 1){
            scrollView.isScrollEnabled = false
        }
        else{
            scrollView.isScrollEnabled = true
        }
        
        for i in 0..<clothesImages.count{
            let clothe = clothesImages[i] as! Clothe
            //let imageView = UIImageView(image: UIImage(data: clothe.image))
            let imageView = UIImageView(image: clothe.image)
            //imageView.contentMode = .f
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        for(index, imageView) in imageViews.enumerated(){
            imageView.frame.size = CGSize(width: height, height: height)
            imageView.frame.origin.x = height * CGFloat(index)
            imageView.frame.origin.y = 0
            imageView.backgroundColor = nil
        }
        let contentWidth  = height * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: height)
    }
    
}
