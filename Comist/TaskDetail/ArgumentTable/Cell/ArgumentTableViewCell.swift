//
//  ArgumentTableViewCell.swift
//  Comist
//
//  Created by dewill on 24.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class ArgumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var argTextLabel: UILabel!
    
    static let identifier = "ArgumentTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        argTextLabel.textColor = .black

    }
    
    func setTextColor(value: Int){
        var color: UIColor?
        switch value {
        case 1: color = UIColor.black.withAlphaComponent(0.3)
        case 2:  color = UIColor.black.withAlphaComponent(0.6)
        default:
            color = .black
        }
        valueLabel.textColor = color
        argTextLabel.textColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
