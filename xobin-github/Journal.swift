//
//  Journal.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 16/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class Journal: NSObject {
  
  internal static let sharedInstance = Journal()
  let moc = Utils.getContext()

  func storeIssuesToCoreData(json: JSON?) {
    if let jsonArray = json?.array {
      for jsonData in jsonArray {
        let issue: Issue = Issue(context:moc)
        issue.buildFromDictionary(json: jsonData)
        do {
          try moc.save()
        } catch {
          print("moc error")
        }
        ApiController.sharedController.getAllCommentsFrom(issue: issue)
      }
    }
  }
  
  func storeCommentsToCoreData(json: JSON?, issue: Issue) {
    if let jsonArray = json?.array {
      for jsonData in jsonArray {
        let comment: Comment = Comment(context:moc)
        comment.buildFromDictionary(json: jsonData, issue: issue)
        do {
          try moc.save()
        } catch {
          print("moc error")
        }
      }
    }
  }
  
}
