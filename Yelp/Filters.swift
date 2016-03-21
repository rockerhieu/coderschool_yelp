//
//  File.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

@objc class CategoryFilter: NSObject {
    var name: String
    var code: String
    var checked: Bool
    init(name: String, code: String, checked: Bool) {
        self.name = name
        self.code = code
        self.checked = checked
    }
}

@objc class DistanceFilter: NSObject {
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

@objc class SortByFilter: NSObject {
    var sortMode: YelpSortMode
    var text: String {
        get {
            switch sortMode {
            case .BestMatched: return "Best Match"
            case .Distance: return "Distance"
            case .HighestRated: return "Highest Rate"
            }
        }
    }

    init(sortMode: YelpSortMode = .Distance) {
        self.sortMode = sortMode
    }
}

@objc class Filters: NSObject {
    var distanceFilters: [DistanceFilter]!
    var sortByFilters: [SortByFilter]!
    var categoryFilters: [CategoryFilter]!

    var isOfferingADeal: Bool!
    var selectedDistanceFilter: DistanceFilter!
    var selectedSortByFilter: SortByFilter!
    var selectedCategories: [String] {
        get {
            var selected = [String]()
            for categoryFilter in categoryFilters {
                if categoryFilter.checked {
                    selected.append(categoryFilter.code)
                }
            }
            return selected
        }
    }

    override init() {
        distanceFilters = [DistanceFilter(distance: 0), DistanceFilter(distance: 0.3), DistanceFilter(distance: 1), DistanceFilter(distance: 5), DistanceFilter(distance: 20)]
        sortByFilters = [SortByFilter(sortMode: .BestMatched), SortByFilter(sortMode: .Distance), SortByFilter(sortMode: .HighestRated)]
        categoryFilters = [
            CategoryFilter(name: "American (New)", code: "newamerican", checked: false),
            CategoryFilter(name: "American (Traditional)", code: "tradamerican", checked: false),
            CategoryFilter(name: "Argentine", code: "argentine", checked: false),
            CategoryFilter(name: "Asian Fusion", code: "asianfusion", checked: false),
            CategoryFilter(name: "Australian", code: "australian", checked: false),
            CategoryFilter(name: "Austrian", code: "austrian", checked: false),
            CategoryFilter(name: "Baguettes", code: "baguettes", checked: false),
            CategoryFilter(name: "Barbeque", code: "bbq", checked: false),
            CategoryFilter(name: "Basque", code: "basque", checked: false),
            CategoryFilter(name: "Beer Garden", code: "beergarden", checked: false),
            CategoryFilter(name: "Brazilian", code: "brazilian", checked: false),
            CategoryFilter(name: "British", code: "british", checked: false),
            CategoryFilter(name: "Buffets", code: "buffets", checked: false),
            CategoryFilter(name: "Burgers", code: "burgers", checked: false),
            CategoryFilter(name: "Burmese", code: "burmese", checked: false),
            CategoryFilter(name: "Cafes", code: "cafes", checked: false),
            CategoryFilter(name: "Cafeteria", code: "cafeteria", checked: false),
            CategoryFilter(name: "Cajun/Creole", code: "cajun", checked: false),
            CategoryFilter(name: "Cambodian", code: "cambodian", checked: false),
            CategoryFilter(name: "Caribbean", code: "caribbean", checked: false),
            CategoryFilter(name: "Catalan", code: "catalan", checked: false),
            CategoryFilter(name: "Cheesesteaks", code: "cheesesteaks", checked: false),
            CategoryFilter(name: "Chicken Shop", code: "chickenshop", checked: false),
            CategoryFilter(name: "Chicken Wings", code: "chicken_wings", checked: false),
            CategoryFilter(name: "Chinese", code: "chinese", checked: false),
            CategoryFilter(name: "Comfort Food", code: "comfortfood", checked: false),
            CategoryFilter(name: "Creperies", code: "creperies", checked: false),
            CategoryFilter(name: "Cuban", code: "cuban", checked: false),
            CategoryFilter(name: "Czech", code: "czech", checked: false),
            CategoryFilter(name: "Delis", code: "delis", checked: false),
            CategoryFilter(name: "Diners", code: "diners", checked: false),
            CategoryFilter(name: "Fast Food", code: "hotdogs", checked: false),
            CategoryFilter(name: "Food Court", code: "food_court", checked: false),
            CategoryFilter(name: "Food Stands", code: "foodstands", checked: false),
            CategoryFilter(name: "Vietnamese", code: "vietnamese", checked: false)
        ]
        
        isOfferingADeal = false
        selectedDistanceFilter = distanceFilters[0]
        selectedSortByFilter = sortByFilters[0]
    }
}