//
//  PickerViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 03.01.2020.
//  Copyright © 2020 Lev Butkovskiy. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.alpha = 0.25
    }
    
    func selectDate(){
        let vc = DatePickerTableView()
        self.present(vc, animated: true, completion: nil)
    }
}
