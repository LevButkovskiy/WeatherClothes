//
//  ResultTableViewCell.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 08/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clotheName: UILabel!
    @IBOutlet weak var clotheDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var height = CGFloat()
    var clothes = Array<Clothe>()
    
    var appearance = Appearance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "resultCollectionCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard clothes.count < 0 else {
            return clothes.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCollectionCell", for: indexPath) as! ResultCollectionViewCell
        guard clothes.count < 0 else {
            let clothe = clothes[indexPath.row]
            cell.setImages(imageName: clothe.imageName, color: .green)
            /*let image = UIImage(named: "tshirt_white")
            let imageOver = image?.applyOverlayWithColor(color: .green, blendMode: .color, alpha: 0.5)
            cell.backView.image = imageOver*/
            //cell.topView.image = imageOver
            
            //cell.backView.tintColor = clothe.color
            //cell.topView.image = UIImage(named: String(format: "%@_frame", clothe.imageName.lowercased()))
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    /*func setTheme(){
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
    }*/
    
    
    /*func setImages(){
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
 
    }*/

}

extension UIImage {
    func applyOverlayWithColor(color: UIColor, blendMode: CGBlendMode) -> UIImage? {
        // Create a new CGContext
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let bounds = CGRect(origin: CGPoint.zero, size: self.size)
        let context = UIGraphicsGetCurrentContext()
        // Draw image into context, then fill using the proper color and blend mode
        draw(in: bounds, blendMode: .normal, alpha: 1.0)
        context?.setBlendMode(blendMode)
        context?.setFillColor(color.cgColor)
        context?.fill(bounds)
        // Return the resulting image
        let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return overlayImage
    }
    
    func applyOverlayWithColor(color: UIColor, blendMode: CGBlendMode, alpha: CGFloat) -> UIImage? {
        return applyOverlayWithColor(color: color.withAlphaComponent(alpha), blendMode: blendMode)
    }
}
