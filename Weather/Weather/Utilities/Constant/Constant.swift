//
//  Constant.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    static let apiVersion = "2.5"
    static let apiKey = "bc99fe844057a4c2f404d289b589c7fe"
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    struct ServiceStatusCode {
        static let code = "cod"
    }
    struct Services {
        static let weatherService = apiVersion + "/weather"
    }
    
    struct ServicesQueryParameters {
        static let id = "id"
        static let metric = "metric"
        static let group = "group"
        static let units = "units"
        static let appId = "appid"
    }
    
    struct Controlleridentifier {
        static let cityDetailViewController = "CityDetailViewController"
    }
    
    struct CellIdentifier {
        static let cityInfoTableViewCell = "CityInfoTableViewCell"
    }
   
    
    //MARK: Core Data
    struct EntityName {
        static let cityWeatherInfo = "CityWeatherInfo"
        static let cityWeatherDetail = "CityWeatherDetail"
    }
    
    struct PredicateParameter {
        static let name = "name"
    }
}
