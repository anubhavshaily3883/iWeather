//
//  AppDelegate.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let getWeatherService = GetWeatherService()
    var serviceCallingTimer : Timer?
    
    enum CityId: Int64 {
        case Sydney = 4163971
        case Melbourne = 2147714
        case Brisbane = 2174003
    }
    var groupCityWeatherType = {() -> String in
        return "\(Constant.apiVersion)/\(Constant.ServicesQueryParameters.group)?\(Constant.ServicesQueryParameters.id)=\(CityId.Sydney.rawValue),\(CityId.Melbourne.rawValue),\(CityId.Brisbane.rawValue)" + "&\(Constant.ServicesQueryParameters.units)=\(Constant.ServicesQueryParameters.metric)" + "&\(Constant.ServicesQueryParameters.appId)=\(Constant.apiKey)"
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // PersistentModel.sharedInstance.mainManagedObjectContext//.saveContext()
    }
    
    // Add the timer of 5 mins (Application Level) to get updated data
    func startServiceCall()  {
        serviceCallingTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.callForGetCityWeatherInfoService), userInfo: nil, repeats: true)
        
    }
    
    deinit {
        serviceCallingTimer?.invalidate()
    }
    
    /// Giving Service call to get city weather list
    
    // service calling in background and update the coredata records in background context
    
    @objc func callForGetCityWeatherInfoService() -> Void {
        let serviceType = groupCityWeatherType()
        getWeatherService.callForGetCityWeatherService(serviceType, parameters: nil) { (response, error) in
            if response != nil {
                guard let list = response as? Data else { return }
                do {
                    let cityWeatherInfo = try JSONDecoder().decode(CityWeatherInfoRootModel.self, from: list)
                    for infoModel in cityWeatherInfo.list! {
                        DatabaseTaskManager.sharedInstance.saveWeatherInfoViaBackContextDataBase(infoData: infoModel)
                        
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

