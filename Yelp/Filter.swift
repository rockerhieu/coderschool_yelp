//
//  File.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

struct Category {
    var name: String
    var code: String
    var checked: Bool
    init(name: String, code: String, checked: Bool) {
        self.name = name
        self.code = code
        self.checked = checked
    }
}

class Categories {
    var data: [Category]
    init(data: [Category]) {
        self.data = data
    }
}

class DistanceFilter {
    var distance: Double = 0.0 {
        didSet {
            if distance == 0 {
                text = "Auto"
            }
            text =  "\(distance) miles"
        }
    }
    var text: String!
}