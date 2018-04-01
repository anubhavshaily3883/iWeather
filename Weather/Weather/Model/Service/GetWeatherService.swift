//
//  GetWeatherService.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit

class GetWeatherService: BaseService {
    func callForGetCityWeatherService(_ serviceType: String, parameters: NSDictionary?, completionHandler: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        self.setServiceRequestToServer(service: serviceType, httpMethod: .get, params: nil, headers: nil) { (response, error) in
            if error == nil {
                completionHandler(response,nil)
            }
        }
    }
}
