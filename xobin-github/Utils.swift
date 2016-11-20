//
//  Utils.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 16/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreData

class Utils: NSObject {
  
  static let CONTENT_REFRESHED = "CONTENT_REFRESHED"
  
  static func toDate(dateString: String?) -> NSDate? {
    if dateString == nil {
      return nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    return dateFormatter.date(from: dateString!) as NSDate?
  }
  
  static func toDateTimeString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
    return dateFormatter.string(from: date as Date)
  }
  
  static func getContext () -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
  }
  
  static func getIssues () {
    let fetchRequest: NSFetchRequest<Issue> = Issue.fetchRequest()
    do {
      let searchResults = try getContext().fetch(fetchRequest)
      print ("number of issues: = \(searchResults.count)")
    } catch {
      print("Error with request: \(error)")
    }
  }
  
  static func getComments () {
    let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
    do {
      let searchResults = try getContext().fetch(fetchRequest)
      print ("number of comments: = \(searchResults.count)")
    } catch {
      print("Error with request: \(error)")
    }
  }
  
  static func deleteAllIssues() {
    let fetch: NSFetchRequest<Issue> = Issue.fetchRequest()
    let request = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
    try! getContext().execute(request)
  }
  
  
}
