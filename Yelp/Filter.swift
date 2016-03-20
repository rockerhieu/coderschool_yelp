//
//  File.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

enum FilterType: String {
    case Offering = "Offering"
    case Distance = "Distance"
    case SortBy = "Sort By"
    case Category = "Category"
}

struct NameValue {
    var name:String
    var value:AnyObject
}

class Filter {
}