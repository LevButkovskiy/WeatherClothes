//
//  SubscriptionViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 09.05.2020.
//  Copyright © 2020 Lev Butkovskiy. All rights reserved.
//

import UIKit
import ApphudSDK

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
        imageView.layer.cornerRadius = 25
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = .gray
        view.alpha = 0.5
        self.view.addSubview(view)
        let products = Apphud.products()
        Apphud.refreshStoreKitProducts { (products3) in
            print(products3)
            Apphud.purchase(products3.first!) { result in
                if let subscription = result.subscription, subscription.isActive(){
                    print("YES");
                    self.navigationController?.popViewController(animated: true)
                 } else if let purchase = result.nonRenewingPurchase, purchase.isActive(){
                    print("Ops")
                 } else {
                    print("NO")
                 }
                view.removeFromSuperview()
            }
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsOfUse(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!, options: [.universalLinksOnly: false], completionHandler: nil)
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://bluebeakstd.com/weatherclothes/PrivacyPolicy_ru.pdf")!, options: [.universalLinksOnly: false], completionHandler: nil)
    }

}
