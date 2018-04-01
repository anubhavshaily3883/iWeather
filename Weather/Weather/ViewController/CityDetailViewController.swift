//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Administrator on 01/04/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit

class CityDetailViewController: BaseViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    var cityInfoDetail : CityWeatherInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDataToComponants(cityInfoDetail: cityInfoDetail)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignDataToComponants(cityInfoDetail: CityWeatherInfo?) -> Void {
        if let info = cityInfoDetail {
            cityNameLabel.text = info.name
            tempLabel.text = String(format:"%.f", info.weatherInfo?.temp ?? "") + "°"
            minTempLabel.text = String(format:"%.f", info.weatherInfo?.minTemp ?? "") + "°"
            maxTempLabel.text = String(format:"%.f", info.weatherInfo?.maxTemp ?? "") + "°"
            humidityLabel.text = String(format:"%.f", info.weatherInfo?.humidity ?? "") 
        }
    }
    
}
