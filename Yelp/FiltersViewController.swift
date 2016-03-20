//
//  FilterViewController.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import FontAwesome_swift

class FiltersViewController: UIViewController {
    weak var delegate: FiltersViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!

    var filters: [String: AnyObject]?
    var categories: Categories!
    var isSortByExpanded = false
    var isDistanceExpanded = false
    var distanceFilters = [DistanceFilter(distance: 0), DistanceFilter(distance: 0.3), DistanceFilter(distance: 1), DistanceFilter(distance: 5), DistanceFilter(distance: 20)]

    override func viewDidLoad() {
        setupData()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    func setupData() {
        if let _ = filters {
        } else {
            filters = [String: AnyObject]()
            let categories: [Category] = [
                Category(name: "American (New)", code: "newamerican", checked: false),
                Category(name: "American (Traditional)", code: "tradamerican", checked: false),
                Category(name: "Argentine", code: "argentine", checked: false),
                Category(name: "Asian Fusion", code: "asianfusion", checked: false),
                Category(name: "Australian", code: "australian", checked: false),
                Category(name: "Austrian", code: "austrian", checked: false),
                Category(name: "Baguettes", code: "baguettes", checked: false),
                Category(name: "Barbeque", code: "bbq", checked: false),
                Category(name: "Basque", code: "basque", checked: false),
                Category(name: "Beer Garden", code: "beergarden", checked: false),
                Category(name: "Brazilian", code: "brazilian", checked: false),
                Category(name: "British", code: "british", checked: false),
                Category(name: "Buffets", code: "buffets", checked: false),
                Category(name: "Burgers", code: "burgers", checked: false),
                Category(name: "Burmese", code: "burmese", checked: false),
                Category(name: "Cafes", code: "cafes", checked: false),
                Category(name: "Cafeteria", code: "cafeteria", checked: false),
                Category(name: "Cajun/Creole", code: "cajun", checked: false),
                Category(name: "Cambodian", code: "cambodian", checked: false),
                Category(name: "Caribbean", code: "caribbean", checked: false),
                Category(name: "Catalan", code: "catalan", checked: false),
                Category(name: "Cheesesteaks", code: "cheesesteaks", checked: false),
                Category(name: "Chicken Shop", code: "chickenshop", checked: false),
                Category(name: "Chicken Wings", code: "chicken_wings", checked: false),
                Category(name: "Chinese", code: "chinese", checked: false),
                Category(name: "Comfort Food", code: "comfortfood", checked: false),
                Category(name: "Creperies", code: "creperies", checked: false),
                Category(name: "Cuban", code: "cuban", checked: false),
                Category(name: "Czech", code: "czech", checked: false),
                Category(name: "Delis", code: "delis", checked: false),
                Category(name: "Diners", code: "diners", checked: false),
                Category(name: "Fast Food", code: "hotdogs", checked: false),
                Category(name: "Food Court", code: "food_court", checked: false),
                Category(name: "Food Stands", code: "foodstands", checked: false),
                Category(name: "Vietnamese", code: "vietnamese", checked: false)
            ]
            filters?["Distance"] = distanceFilters[0]
            filters?["Category"] = Categories(data: categories)
            filters?["Sort By"] = YelpSortMode.Distance.rawValue
            filters?["Offering a Deal"] = false
        }
        categories = filters!["Category"] as! Categories
    }

    @IBAction func onSearchClicked(sender: AnyObject) {
        delegate?.filtersViewController?(self, didUpdateFilters: filters!)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return self.isDistanceExpanded ? 5 : 1
        case 2: return self.isSortByExpanded ? 3 : 1
        case 3: return categories.data.count
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        if (section == 1) { return "Distance" }
        if (section == 2) { return "Sort By" }
        if (section == 3) { return "Category" }
        return ""
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.data = (name: "Offering a Deal", value: filters?["Offering a Deal"] as! Bool)
            cell.isOfferingADeal = true
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("RadioCell", forIndexPath: indexPath) as! RadioCell
            let distanceFilter = filters?["Distance"] as! DistanceFilter
            cell.checkView.font = UIFont.fontAwesomeOfSize(30)
            if isDistanceExpanded {
                cell.nameView.text = distanceFilters[indexPath.row].text
                cell.checkView.text = String.fontAwesomeIconWithName(distanceFilter.distance == distanceFilters[indexPath.row].distance ? FontAwesome.Check : FontAwesome.CircleO)
            } else {
                cell.nameView.text = distanceFilter.text
                cell.checkView.text = String.fontAwesomeIconWithName(FontAwesome.AngleDown)
            }

            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("RadioCell", forIndexPath: indexPath) as! RadioCell
            let sortBy = filters?["Sort By"] as! Int
            let sortByMode = YelpSortMode(rawValue: sortBy)
            cell.checkView.font = UIFont.fontAwesomeOfSize(30)
            if isSortByExpanded {
                switch indexPath.row {
                case 0:
                    cell.nameView.text = "Best Match"
                    break
                case 1:
                    cell.nameView.text = "Distance"
                    break
                case 2:
                    cell.nameView.text = "Highest Rate"
                    break
                default:break
                }
                cell.checkView.text = String.fontAwesomeIconWithName(sortBy == indexPath.row ? FontAwesome.Check : FontAwesome.CircleO)
            } else {
                cell.checkView.text = String.fontAwesomeIconWithName(FontAwesome.AngleDown)
                switch sortByMode! {
                case .BestMatched:
                    cell.nameView.text = "Best Match"
                    break
                case .Distance:
                    cell.nameView.text = "Distance"
                    break
                case .HighestRated:
                    cell.nameView.text = "Highest Rate"
                    break
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.isOfferingADeal = false
            cell.delegate = self
            let category = categories.data[indexPath.row]
            cell.data = (name: category.name, value: category.checked)
            return cell
        }
    }
    
    func switchCell(cell: SwitchCell, didChangeValue value: Bool) {
        if cell.isOfferingADeal {
            filters?["Offering a Deal"] = value
        } else {
            let indexPath = tableView.indexPathForCell(cell)
            categories.data[indexPath!.row].checked = value
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:break
        case 1:
            if isDistanceExpanded {
                filters?["Distance"] = distanceFilters[indexPath.row]
            }
            isDistanceExpanded = !isDistanceExpanded
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            break
        case 2:
            if isSortByExpanded {
                filters?["Sort By"] = indexPath.row
            }
            isSortByExpanded = !isSortByExpanded
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            break
        case 3:break
        default:break
        }
    }
}