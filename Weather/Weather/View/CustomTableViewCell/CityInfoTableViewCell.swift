//
//  CityInfoTableViewCell.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit

class CityInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /// Assign data to cell's componant
    ///
    /// - Parameter city: city
    func setDataSource(city: CityWeatherInfo) -> Void {
        timeLabel.text = city.date.getTimeFromTimeStamp()
        tempLabel.text = String(format:"%.f", city.weatherInfo?.temp ?? "") 
        cityNameLabel.text = city.name
    }

}
