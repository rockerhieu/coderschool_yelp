//
//  FilterViewController.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    weak var delegate: FiltersViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [[String: String]]()
    var switchStates = [Int:Bool]()

    override func viewDidLoad() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        categories = yelpCategories()
    }

    @IBAction func onSearchClicked(sender: AnyObject) {
        // delegate?.onFilterChanged(filter)
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        for (row, on) in switchStates {
            if on {
                selectedCategories.append(categories[row]["alias"]!)
            }
        }
        if (selectedCategories.count > 0) {
            filters["categories"] = selectedCategories
        }
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    func yelpCategories() -> [[String: String]] {
        return [
            [                "alias": "afghani",                "title": "Afghan"            ],
            [                "alias": "african",                "title": "African"            ],
            [                "title": "Andalusian",                "alias": "andalusian"            ],
            [                "alias": "arabian",                "title": "Arabian"            ],
            [                "alias": "argentine",                "title": "Argentine"            ],
            [                "title": "Armenian",                "alias": "armenian"            ],
            [                "alias": "asianfusion",                "title": "Asian Fusion"            ],
            [                "title": "Asturian",                "alias": "asturian"            ],
            [                "alias": "australian",                "title": "Australian"            ],
            [                "alias": "austrian",                "title": "Austrian"            ],
            [                "title": "Baguettes",                "alias": "baguettes"            ],
            [                "alias": "bangladeshi",                "title": "Bangladeshi"            ],
            [                "alias": "basque",                "title": "Basque"            ],
            [                "title": "Bavarian",                "alias": "bavarian"            ],
            [                "alias": "bbq",                "title": "Barbeque"            ],
            [                "title": "Beer Garden",                "alias": "beergarden"            ],
            [                "title": "Beer Hall",                "alias": "beerhall"            ],
            [                "title": "Beisl",                "alias": "beisl"            ],
            [                "alias": "belgian",                "title": "Belgian"            ],
            [                "alias": "bistros",                "title": "Bistros"            ],
            [                "title": "Black Sea",                "alias": "blacksea"            ],
            [                "alias": "brasseries",                "title": "Brasseries"            ],
            [                "alias": "brazilian",                "title": "Brazilian"            ],
            [                "alias": "breakfast_brunch",                "title": "Breakfast & Brunch"            ],
            [                "alias": "british",                "title": "British"            ],
            [                "alias": "buffets",                "title": "Buffets"            ],
            [                "alias": "bulgarian",                "title": "Bulgarian"            ],
            [                "alias": "burgers",                 "title": "Burgers"            ],
            [                "alias": "burmese",                 "title": "Burmese"            ],
            [                "alias": "cafes",                 "title": "Cafes"            ],
            [                "alias": "cafeteria",                 "title": "Cafeteria"            ],
            [                "alias": "cajun",                 "title": "Cajun/Creole"            ],
            [                "alias": "cambodian",                 "title": "Cambodian"            ],
            [                "title": "Canteen",                "alias": "canteen"            ],
            [                "alias": "caribbean",                 "title": "Caribbean"            ],
            [                "title": "Catalan",                 "alias": "catalan"            ],
            [                "title": "Cheesesteaks",                "alias": "cheesesteaks"            ],
            [                "title": "Chicken Wings",                "alias": "chicken_wings"            ],
            [                "alias": "chickenshop",                 "title": "Chicken Shop"            ]
        ]
    }
}

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.delegate = self
        cell.nameView.text = categories[indexPath.row]["title"]
        cell.valueView.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(cell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(cell)
        switchStates[indexPath!.row] = value
    }
}