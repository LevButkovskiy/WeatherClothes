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
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    var height = CGFloat()
    var images = [UIImage]()
    var imageViews = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadImf(){
        
        height = self.frame.height - 20
        scrollView.layer.cornerRadius = 15
        scrollView.layer.shadowColor = UIColor.lightGray.cgColor
        scrollView.layer.shadowOpacity = 1
        scrollView.layer.shadowOffset = .zero
        scrollView.layer.shadowRadius = 3
        
        for image in images{
            //let image = UIImage.init(named: name)
            let imageView = UIImageView(image: image)
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
