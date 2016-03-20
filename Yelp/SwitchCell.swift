//
//  CategoryFilterCell.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var valueView: UISwitch!
    weak var delegate: SwitchCellDelegate?

    var data: NameValue! {
        didSet {
            nameView.text = data.name
            valueView.on = data.value as! Bool
        }
    }
    @IBAction func onValueChanged(sender: UISwitch) {
        delegate?.switchCell?(self, didChangeValue: sender.on)
    }
}

@objc protocol SwitchCellDelegate {
    optional func switchCell(cell: SwitchCell, didChangeValue value: Bool)
}