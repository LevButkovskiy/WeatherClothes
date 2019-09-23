//
//  DetailWeather.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 08/09/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class DetailWeather: UIView {
        
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var uvIndex: UILabel!


    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var uvIndexView: UIView!

    var upperPosition : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        associate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func close(_ sender: Any) {
        contentView = nil
        UIView.animate(withDuration: 1.0) {
            self.frame = CGRect(x: 0, y: 1000, width: self.frame.width, height: self.frame.height)
        }
    }
    
    func associate(){
        Bundle.main.loadNibNamed("DetailWeather", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 20
        
        windView.layer.cornerRadius = 15
        humidityView.layer.cornerRadius = 15
        pressureView.layer.cornerRadius = 15
        uvIndexView.layer.cornerRadius = 15
        
        addSubview(contentView)
        show()
    }
    
    func setWeather(weather: Weather){
        windSpeed.text = String(format: "%d %@", weather.windSpeed, "ms".localized)
        humidity.text = String(format: "%d %@", weather.humidity, String("%"))
        pressure.text = String(format: "%d %@", weather.pressure, "mmHg".localized)
        uvIndex.text = String(format: "%.1f %@", weather.uvIndex, "uv".localized)

    }
    func show(){
        UIView.animate(withDuration: 1.0, animations: {
            self.frame = CGRect(x: 0, y: self.upperPosition, width: self.frame.width, height: self.frame.height)
            self.layer.cornerRadius = 20
        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
