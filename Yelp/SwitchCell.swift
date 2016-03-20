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
    var isOfferingADeal = false

    var data: (name: String, value: Bool)? {
        didSet {
            nameView.text = data?.name ?? ""
            valueView.on = data?.value ?? false
        }
    }

    @IBAction func onValueChanged(sender: UISwitch) {
        delegate?.switchCell?(self, didChangeValue: sender.on)
    }
}

@objc protocol SwitchCellDelegate {
    optional func switchCell(cell: SwitchCell, didChangeValue value: Bool)
}