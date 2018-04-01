//
//  DoubleExtension.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import Foundation

extension Double {
    
    func getTimeFromTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        let date = Date(timeIntervalSince1970: self)
        return dateFormatter.string(from: date)
    }
}
