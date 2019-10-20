//
//  HistoryTableViewController.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class HistoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var fetchedResultsController: NSFetchedResultsController<WeatherEntity>?
    private let cellIdentifier = "weatherRequestCell"
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWeatherRequestHistory()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let numberOfRows = sections[section].numberOfObjects
        if numberOfRows == 0 { tableView.setEmptyMessage("   No weather request history found.   ") }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let weatherRequest = fetchedResultsController?.object(at: indexPath)
            else { return cell }
        let resultString = "\(weatherRequest.temperature) Cº - (\(weatherRequest.street),  \(weatherRequest.city))"
        cell.textLabel?.text = resultString
        let resultDate = weatherRequest.requestTime
        cell.detailTextLabel?.text = "\(resultDate)"
        return cell
    }
    
}

@available(iOS 10.0, *)
// MARK: - CoreData Methods
extension HistoryTableViewController: NSFetchedResultsControllerDelegate {
    func setupFetchedResultsController() {
        
        guard let context = ContextSingltone.shared.context else { return }
        let sortDescriptor = NSSortDescriptor(key: "requestTime", ascending: false)
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    func fetchWeatherRequestHistory() {
        do {
            try fetchedResultsController?.performFetch()
        } catch let error {
            print("Fetch history ERROR: \(error.localizedDescription)")
        }
    }
}
