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
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 15
//        cellView.frame = cellView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        setContent()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    var task : TaskEntity? {
        didSet {
            setContent()
        }
    }
    
     func setContent(){
        
        guard let task = task else { return }
        titleLabel?.text = task.title
        descriptionLabel?.text = task.taskDescription
        setBorderColor(cellState: ComistType(rawValue: Int(task.state))!)
        
    }
    
    private func setBorderColor(cellState: ComistType){
        var color: UIColor = .white
        switch cellState {
        case .negative: color = Style.Color.redBorder.get()
        case .positive: color = Style.Color.greenBorder.get()
        default: break
            }
        view.layer.borderColor = color.cgColor
    }
}


