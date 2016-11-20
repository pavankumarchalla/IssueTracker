//
//  CommentCell.swift
//  xobin-github
//
//  Created by Pavan Kumar C on 17/11/16.
//  Copyright © 2016 Pavan Kumar CSedin. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var personLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!

  func configure(comment: Comment) {
    
    bodyLabel.text = comment.body
    personLabel.text = comment.userName
    
    if let createdDate = comment.createdAt {
      createdAtLabel.text = Utils.toDateTimeString(date: createdDate as Date)
    } else {
      createdAtLabel.text = ""
    }
    
  }
}
