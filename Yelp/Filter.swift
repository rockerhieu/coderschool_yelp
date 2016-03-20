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
    var distance = 0.0
    var distanceInMeters: Double {
        get {
            return distance * 1609.34
        }
    }
    var text: String {
        get {
            if distance == 0.0 {
                return "Auto"
            }
            if (distance == 1) {
                return "1 mile"
            }
            if (distance % 1 == 0) {
                return "\(Int(distance)) miles"
            } else {
                return "\(distance) miles"
            }
        }
    }
    
    init(distance: Double) {
        self.distance = distance
    }
}