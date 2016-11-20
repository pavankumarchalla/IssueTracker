//
//  ApiController.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 15/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiController: NSObject {
  
  internal static let sharedController = ApiController()
  private let BASE_URL = "https://api.github.com/repos/crashlytics/secureudid/issues"
  
  func fetchAllIssues() {
    Alamofire.request(BASE_URL).responseJSON { response in
      switch response.result {
      case .success(let data):
        Utils.deleteAllIssues()
        print("Before persisting: \(Utils.getIssues()) ")
        Journal.sharedInstance.storeIssuesToCoreData(json: JSON(data))
        print("After persisting: \(Utils.getIssues()) ")
      case .failure(let error):
        print(error.localizedDescription)
      }
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.CONTENT_REFRESHED), object: nil)
    }
  }
  
  func getAllCommentsFrom(issue: Issue) {
    
    let urlString = "\(BASE_URL)/\(issue.number)/comments"
    
    Alamofire.request(urlString).responseJSON { response in
      switch response.result {
      case .success(let data):
        print("Before persisting: \(Utils.getComments()) ")
        Journal.sharedInstance.storeCommentsToCoreData(json: JSON(data), issue: issue)
        print("After persisting: \(Utils.getComments()) ")
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
  }
  

}
