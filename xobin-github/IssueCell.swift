//
//  IssueCell.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 17/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit

class IssueCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  
  
  func configureView(issue: Issue) {
    titleLabel.text = issue.title
    
    if let bodyText = issue.body {
      let index = bodyText.index(bodyText.startIndex, offsetBy: 140)
      bodyLabel.text = "\(bodyText.substring(to: index)) ..."
    }
    
  }

}
