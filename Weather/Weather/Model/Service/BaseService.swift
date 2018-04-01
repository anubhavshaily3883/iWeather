//
//  BaseService.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import Foundation
import Alamofire

class BaseService: NSObject {
    
    enum Response: Int {
        //Enum for response
        case success = 200
        case authentication_failed = 401
    }
    
    private var getURLString = {(apiName : String) -> String in
        let baseURL = "http://api.openweathermap.org/data/"
        return baseURL + String(format: "%@", apiName)
    }
    
    //MARK:Custom Methods
    
    func setServiceRequestToServer(service: String!, httpMethod: HTTPMethod, params: NSDictionary?, headers: HTTPHeaders?, completionHandler: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        // Almofire request
        let encoding: ParameterEncoding = URLEncoding.default
        Alamofire.request(getURLString(service), method: httpMethod, parameters: params as? Parameters, encoding: encoding, headers: headers).responseString { (response) in
            self.handleServiceResponse(response: response, completionHandler: completionHandler)
        }
    }
    
    func handleServiceResponse(response: DataResponse<String>, completionHandler: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        switch response.result {
        case .success :
            switch (response.response?.statusCode)!
            {
            case Response.success.rawValue :
                do{
                    let responseJSON = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments ) as! NSDictionary
                    // Serialized JSON
                    let dataDictionary = ((responseJSON[Constant.ServiceStatusCode.code] != nil) ? responseJSON[Constant.ServiceStatusCode.code] : responseJSON) as? NSDictionary
                    if ((dataDictionary?.count) != 0) {
                        completionHandler(response.data as AnyObject, nil)
                    } else {
                        completionHandler(nil, response.result.error as NSError?)
                    }
                }catch let error as NSError
                {
                    completionHandler(nil, error)
                }
                break
                
            default:
                do {
                    if let data = response.data {
                        let errorObject = try JSONDecoder().decode(ErrorObject.self, from: data)
                        let error = NSError(domain: errorObject.message, code: Int(errorObject.cod)! , userInfo: [NSLocalizedDescriptionKey : errorObject.message])
                        completionHandler(nil, error)
                    }
                }catch let error {
                    completionHandler(nil, error as NSError)
                }
                
                break
            }
            break
            
        case .failure(let error):
            completionHandler(nil, error as NSError?)
            break
        }
    }
}

