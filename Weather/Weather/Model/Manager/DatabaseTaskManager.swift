//
//  DatabaseTaskManager.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit
import CoreData

class DatabaseTaskManager: NSObject {
    static let sharedInstance = DatabaseTaskManager()
    let persistentObject = PersistentModel.sharedInstance
   
    //MARK: Custom methods
    
    /// Insert or update core data records
    ///
    /// - Parameter infoData: updated Data from response
    override init() {
    }
    
    func saveWeatherInfoToDataBase(infoData: CityWeatherInfoModel?) -> Void {
        let objectArray = self.fetchDataBaseRecords(entityName: Constant.EntityName.cityWeatherInfo, id: infoData?.id) as? Array<CityWeatherInfo>
        // Check city exist or not
        if objectArray != nil && objectArray?.count != 0 {
            let cityWeatherInfo = objectArray![0]
            if let weatherInfo = infoData {
                // if true then update values
                self.insertOrUpdateValues(cityWeatherInfo: cityWeatherInfo, cityWeatherDetail: cityWeatherInfo.weatherInfo!, updatedData: weatherInfo)
            }
        } else {
            if let weatherInfo = infoData
            {
                let cityWeatherInfo = NSEntityDescription.insertNewObject(forEntityName: Constant.EntityName.cityWeatherInfo, into:persistentObject.mainManagedObjectContext) as! CityWeatherInfo
                let cityWeatherDetail = NSEntityDescription.insertNewObject(forEntityName: Constant.EntityName.cityWeatherDetail, into:persistentObject.mainManagedObjectContext) as! CityWeatherDetail
                // else insert records
                self.insertOrUpdateValues(cityWeatherInfo: cityWeatherInfo, cityWeatherDetail: cityWeatherDetail, updatedData: weatherInfo)
            }
        }
    }


    
    /// Save changes in Core data
    func saveAttributes() -> Void {
        do {
            try persistentObject.mainManagedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    /// fetch data by city id
    ///
    /// - Parameters:
    ///   - entityName: Name of Entity
    ///   - id: city id
    /// - Returns: array of objects
    func fetchDataBaseRecords(entityName: String, id: Double?) -> AnyObject? {
        var array: Array<AnyObject>?
            let entityDescription =
                NSEntityDescription.entity(forEntityName: entityName,
                                           in: persistentObject.mainManagedObjectContext)
            let request = NSFetchRequest<NSFetchRequestResult>()
            if let cityId = id {
                request.predicate = NSPredicate(format: "id == %lf", cityId)
            }
            request.entity = entityDescription
            do{
                let objects = try persistentObject.mainManagedObjectContext.fetch(request)
                array = objects as Array<AnyObject>
            }catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        return array as AnyObject
    }
    
    /// insert or update records with response
    ///
    /// - Parameters:
    ///   - cityWeatherInfo:cityWeatherInfo
    ///   - cityWeatherDetail: cityWeatherDetail
    ///   - updatedData: response data
    func insertOrUpdateValues(cityWeatherInfo: CityWeatherInfo,cityWeatherDetail: CityWeatherDetail,updatedData: CityWeatherInfoModel) -> Void {
        cityWeatherInfo.date = updatedData.dt
        cityWeatherInfo.name = updatedData.name
        cityWeatherInfo.id = updatedData.id
        cityWeatherDetail.temp = updatedData.main.temp // we can update temp when it changes by putting condition here
        cityWeatherDetail.maxTemp = updatedData.main.tempMax
        cityWeatherDetail.minTemp = updatedData.main.tempMin
        cityWeatherDetail.pressure = updatedData.main.pressure
        cityWeatherDetail.humidity = updatedData.main.humidity
        cityWeatherInfo.weatherInfo = cityWeatherDetail
        self.saveAttributes()
    }
    
    // MARK: Background Fetch Operation
    
    // Get data after every 5 mins in background and update core data records in background manage object context
    
    func saveWeatherInfoViaBackContextDataBase(infoData: CityWeatherInfoModel?) -> Void {
        let objectArray = self.fetchDataBaseRecordsViaBackgroundContext(entityName: Constant.EntityName.cityWeatherInfo, id: infoData?.id) as? Array<CityWeatherInfo>
        // Check city exist or not
        if objectArray != nil && objectArray?.count != 0 {
            let cityWeatherInfo = objectArray![0]
            if let weatherInfo = infoData {
                // if true then update values
                self.insertOrUpdateValuesViaBackgroudContext(cityWeatherInfo: cityWeatherInfo, cityWeatherDetail: cityWeatherInfo.weatherInfo!, updatedData: weatherInfo)
            }
        } else {
            if let weatherInfo = infoData
            {
                let cityWeatherInfo = NSEntityDescription.insertNewObject(forEntityName: Constant.EntityName.cityWeatherInfo, into:self.persistentObject.backmanagedObjectContext) as! CityWeatherInfo
                let cityWeatherDetail = NSEntityDescription.insertNewObject(forEntityName: Constant.EntityName.cityWeatherDetail, into:self.persistentObject.backmanagedObjectContext) as! CityWeatherDetail
                // else insert records
                self.insertOrUpdateValuesViaBackgroudContext(cityWeatherInfo: cityWeatherInfo, cityWeatherDetail: cityWeatherDetail, updatedData: weatherInfo)
            }
        }
    }
    
    func fetchDataBaseRecordsViaBackgroundContext(entityName: String, id: Double?) -> AnyObject? {
        var array: Array<AnyObject>?
        persistentObject.backmanagedObjectContext.performAndWait {
            let entityDescription =
                NSEntityDescription.entity(forEntityName: entityName,
                                           in:  persistentObject.backmanagedObjectContext)
            let request = NSFetchRequest<NSFetchRequestResult>()
            if let cityId = id {
                request.predicate = NSPredicate(format: "id == %lf", cityId)
            }
            request.entity = entityDescription
            do{
                let objects = try  persistentObject.backmanagedObjectContext.fetch(request)
                array = objects as Array<AnyObject>
            }catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        return array as AnyObject
    }
    
    func insertOrUpdateValuesViaBackgroudContext(cityWeatherInfo: CityWeatherInfo,cityWeatherDetail: CityWeatherDetail,updatedData: CityWeatherInfoModel) -> Void {
        persistentObject.backmanagedObjectContext.performAndWait {
            cityWeatherInfo.date = updatedData.dt
            cityWeatherInfo.name = updatedData.name
            cityWeatherInfo.id = updatedData.id
            cityWeatherDetail.temp = updatedData.main.temp // we can update temp when it changes by putting condition here
            cityWeatherDetail.maxTemp = updatedData.main.tempMax
            cityWeatherDetail.minTemp = updatedData.main.tempMin
            cityWeatherDetail.pressure = updatedData.main.pressure
            cityWeatherDetail.humidity = updatedData.main.humidity
            cityWeatherInfo.weatherInfo = cityWeatherDetail
            if (persistentObject.backmanagedObjectContext.hasChanges) {
                do{
                    try persistentObject.backmanagedObjectContext.save()
                }catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        persistentObject.backmanagedObjectContext.parent?.performAndWait({
            self.saveAttributes()
        })
    }
}
