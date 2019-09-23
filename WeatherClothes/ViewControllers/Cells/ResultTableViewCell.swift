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
    var clothes = Array<Any>()
    var imageViews = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        if(clothes.count == 1){
            scrollView.isScrollEnabled = false
        }
        else{
            scrollView.isScrollEnabled = true
        }
        
        for i in 0..<clothes.count{
            let clothe = clothes[i] as! Dictionary<String, Any>
            let imageView = UIImageView(image: (clothe["image"] as? UIImage))
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
    
}
