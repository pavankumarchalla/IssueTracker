//
//  IssueViewController.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 15/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit
import CoreData

class IssueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

  @IBOutlet weak var issueTableView: UITableView! {
    didSet {
      issueTableView.tableFooterView = UIView()
    }
  }
  
  var fetchedResults:NSFetchedResultsController<Issue>?
  let moc = Utils.getContext()
  var refreshControl:UIRefreshControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    issueTableView.rowHeight = UITableViewAutomaticDimension
    issueTableView.estimatedRowHeight = 60.0
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(IssueViewController.refreshPulled), for: .valueChanged)
    issueTableView.addSubview(refreshControl)
    
    NotificationCenter.default.addObserver(self, selector: #selector(IssueViewController.endRefreshing), name: NSNotification.Name(rawValue: Utils.CONTENT_REFRESHED), object: nil)

    setFetchedRequestController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
  }

  //MARK:- UITableView delegate and datasource methods 
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let numObjects = fetchedResults?.sections?[0].numberOfObjects {
      return numObjects
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell", for: indexPath) as! IssueCell
    if let issue = fetchedResults?.object(at: indexPath) {
      cell.configureView(issue: issue)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let issue = fetchedResults?.object(at: indexPath) {
      let comment = CommentViewController.storyBoardInstance()
      comment.issue = issue
      self.navigationController?.pushViewController(comment, animated: true)
    }
  }
  
  // MARK: - NSFetchResultsController delegate methods
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
      
    case .update:
      print("Update Issue at \(indexPath!.row)")
      issueTableView.reloadRows(at: [indexPath! as IndexPath], with: .automatic)
      
    case .insert:
      print("Insert Issue at \(newIndexPath!.row)")
      issueTableView.insertRows(at: [newIndexPath! as IndexPath], with: .fade)
      
    case .delete:
      print("Delete Issue at \(indexPath!.row)")
      print(controller.fetchRequest)
      issueTableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
      
    case .move:
      print("Moved Issue at \(indexPath!.row)")
      if indexPath == newIndexPath {
        issueTableView.reloadRows(at: [newIndexPath! as IndexPath], with: .none)
      } else {
        issueTableView.moveRow(at: indexPath! as IndexPath, to: newIndexPath! as IndexPath)
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    issueTableView.endUpdates()
    issueTableView.reloadData()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    issueTableView.beginUpdates()
  }
  
  //MARK:- Custom methods
  
  private func setFetchedRequestController() {
    let fetchRequest = NSFetchRequest<Issue>(entityName: "Issue")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    fetchRequest.returnsObjectsAsFaults = false
    fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResults?.delegate = self
    fetchUsingFetchResultsController()
  }
  
  private func fetchUsingFetchResultsController() {
    do {
      try fetchedResults?.performFetch()
      issueTableView.reloadData()
    } catch let error as NSError {
      print("Error Fetching UsingResults controller \(error)")
    }
  }
  
  func refreshPulled()  {
    ApiController.sharedController.fetchAllIssues()
  }
  
  func endRefreshing() {
    refreshControl.endRefreshing()
    setFetchedRequestController()
  }
  
}

