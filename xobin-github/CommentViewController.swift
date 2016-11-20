//
//  CommentViewController.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 17/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit
import CoreData

class CommentViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var issueTitle: UILabel!
  @IBOutlet weak var issueDescriptionTextView: UITextView!
  @IBOutlet weak var issuePersonLabel: UILabel!
  @IBOutlet weak var issueCreatedAtLabel: UILabel!
  @IBOutlet weak var commentsTableView: UITableView! {
    didSet {
      commentsTableView.tableFooterView = UIView()
    }
  }
  let moc = Utils.getContext()
  var fetchedResults:NSFetchedResultsController<Comment>?
  var issue: Issue?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    commentsTableView.rowHeight = UITableViewAutomaticDimension
    commentsTableView.estimatedRowHeight = 60.0
    configureView()
    setFetchedRequestController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.navigationController?.navigationBar.tintColor = UIColor.white
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    issueDescriptionTextView.setContentOffset(CGPoint.zero, animated: false)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    if let comment = fetchedResults?.object(at: indexPath) {
      cell.configure(comment: comment)
    }
    return cell
    
  }
  
  // MARK: - NSFetchResultsController delegate methods
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .update:
      print("Update Issue at \(indexPath!.row)")
      commentsTableView.reloadRows(at: [indexPath! as IndexPath], with: .automatic)
      
    case .insert:
      print("Insert Comment at \(newIndexPath!.row)")
      commentsTableView.insertRows(at: [newIndexPath! as IndexPath], with: .fade)
      
    case .delete:
      print("Delete Comment at \(indexPath!.row)")
      print(controller.fetchRequest)
      commentsTableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
      
    case .move:
      print("Moved Comment at \(indexPath!.row)")
      if indexPath == newIndexPath {
        commentsTableView.reloadRows(at: [newIndexPath! as IndexPath], with: .none)
      } else {
        commentsTableView.moveRow(at: indexPath! as IndexPath, to: newIndexPath! as IndexPath)
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    commentsTableView.endUpdates()
    commentsTableView.reloadData()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    commentsTableView.beginUpdates()
  }
  
  //MARK:- Custom methods
  static func storyBoardInstance() -> CommentViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
  }
  
  func configureView() {
    issueTitle.text = issue?.title
    issueDescriptionTextView.isScrollEnabled = false
    issueDescriptionTextView.text = issue?.body
    issueDescriptionTextView.isScrollEnabled = true
    issuePersonLabel.text = issue?.userName
    if let createdDate = issue?.createdAt {
      issueCreatedAtLabel.text = Utils.toDateTimeString(date: createdDate as Date)
    } else {
      issueCreatedAtLabel.text = ""
    }
  }
  
  private func setFetchedRequestController() {
    let fetchRequest = NSFetchRequest<Comment>(entityName: "Comment")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    fetchRequest.predicate = NSPredicate(format: "issue = %@", issue!)
    fetchRequest.returnsObjectsAsFaults = false
    fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResults?.delegate = self
    fetchUsingFetchResultsController()
  }
  
  private func fetchUsingFetchResultsController() {
    do {
      try fetchedResults?.performFetch()
      commentsTableView.reloadData()
    } catch let error as NSError {
      print("Error Fetching UsingResults controller \(error)")
    }
  }
  
}
