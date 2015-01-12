//
//  TaskCell.swift
//  Taskit
//
//  Created by John Mulholland on 05/01/2015.
//  Copyright (c) 2015 John Mulholland. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    /* This class is used to provide a way of accessing the UILabel fields that were set up on the Tasks table view and linked to here via the relevant IBOutlets */
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
