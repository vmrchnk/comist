//
//  TaskTableViewCell.swift
//  Comist
//
//  Created by dewill on 09.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let indentifier  = "TaskTableViewCell.indentifier"
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var argCountTitle: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
//        cellView.layer.borderWidth = 4
//        cellView.layer.borderColor = UIColor.white.cgColor
//        cellView.layer.cornerRadius = 15
        
        setContent()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    var task : TaskModel? {
        didSet {
            setContent()
        }
    }
    
     func setContent(){
        
        guard let task = task else { return }
        titleLabel?.text = task.title
        self.cellView?.backgroundColor = #colorLiteral(red: 0.06891931427, green: 0.6722319162, blue: 0.1261964918, alpha: 1)
        
    }
}


