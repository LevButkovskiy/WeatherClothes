//
//  ResultCollectionViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 12.01.2020.
//  Copyright © 2020 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImages(imageName: String, color: UIColor){
        let bgimg = UIImage(named: String(format: "%@_white", imageName)) // The image used as a background
        let bgimgview = UIImageView(image: bgimg) // Create the view holding the image
        bgimgview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height) // The size of the background image
        bgimgview.tintColor = color
        
        let frontimg = UIImage(named: String(format: "%@_frame", imageName)) // The image in the foreground
        let frontimgview = UIImageView(image: frontimg) // Create the view holding the image
        frontimgview.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height) // The size and position of the front image

        bgimgview.addSubview(frontimgview) // Add the front image on top of the background
        self.addSubview(bgimgview)
    }
}
