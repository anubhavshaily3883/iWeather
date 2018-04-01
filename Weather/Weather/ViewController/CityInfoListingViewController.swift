//
//  CityInfoListingViewController.swift
//  Weather
//
//  Created by Administrator on 31/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import UIKit
import CoreData

class CityInfoListingViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityInfoTableView: UITableView!
    let getWeatherService = GetWeatherService()
    enum CityId: Int64 {
        case Sydney = 4163971
        case Melbourne = 2147714
        case Brisbane = 2174003
    }
    var groupCityWeatherType = {() -> String in
        return "\(Constant.apiVersion)/\(Constant.ServicesQueryParameters.group)?\(Constant.ServicesQueryParameters.id)=\(CityId.Sydney.rawValue),\(CityId.Melbourne.rawValue),\(CityId.Brisbane.rawValue)" + "&\(Constant.ServicesQueryParameters.units)=\(Constant.ServicesQueryParameters.metric)" + "&\(Constant.ServicesQueryParameters.appId)=\(Constant.apiKey)"
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CityWeatherInfo> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<CityWeatherInfo> = CityWeatherInfo.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constant.PredicateParameter.name, ascending: true)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseTaskManager.sharedInstance.persistentObject.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityInfoTableView.tableFooterView = UIView()
        self.callForGetCityWeatherInfoService()
        do {
            try self.fetchedResultsController.performFetch()
            self.cityInfoTableView.reloadData()
            
        } catch {
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Methods
    
    /// Giving Service call to get city weather list
    func callForGetCityWeatherInfoService() -> Void {
        let serviceType = groupCityWeatherType()
        self.showActivityIndicator()
        getWeatherService.callForGetCityWeatherService(serviceType, parameters: nil) { (response, error) in
            self.activityIndicator.stopAnimating()
            if response != nil {
                guard let list = response as? Data else { return }
                do {
                    let cityWeatherInfo = try JSONDecoder().decode(CityWeatherInfoRootModel.self, from: list)
                    
                    for infoModel in cityWeatherInfo.list! {
                        DatabaseTaskManager.sharedInstance.saveWeatherInfoToDataBase(infoData: infoModel)
                    }
                    do {
                        try self.fetchedResultsController.performFetch()
                        self.cityInfoTableView.reloadData()
                        Constant.appDelegate.startServiceCall()
                    } catch {
                        
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func showActivityIndicator() -> Void {
        self.activityIndicator.startAnimating()
        let records = DatabaseTaskManager.sharedInstance.fetchDataBaseRecords(entityName: Constant.EntityName.cityWeatherInfo, id: nil) as? Array<CityWeatherInfo>
        records?.count != 0 ? self.activityIndicator.stopAnimating() : ()
    }
}

extension CityInfoListingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cityList = fetchedResultsController.fetchedObjects else { return 0 }
        return cityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.cityInfoTableViewCell, for: indexPath) as? CityInfoTableViewCell else {
            fatalError("Unexpected Index Path")
            
        }
        let city = fetchedResultsController.object(at: indexPath)
        cell.setDataSource(city: city)
        return cell
    }
}

extension CityInfoListingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityDetail = fetchedResultsController.object(at: indexPath)
        let cityDetailViewController = Constant.storyBoard.instantiateViewController(withIdentifier: Constant.Controlleridentifier.cityDetailViewController) as! CityDetailViewController
        cityDetailViewController.cityInfoDetail = cityDetail
        self.navigationController?.pushViewController(cityDetailViewController, animated: true)
    }
}


extension CityInfoListingViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                cityInfoTableView.insertRows(at: [indexPath], with: .automatic)
            }
        default:
            self.cityInfoTableView.reloadData()
        }
    }
}
