//
//  TypeCollectionViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 09/10/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var type = NSString()
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        // Initialization code
    }

}
