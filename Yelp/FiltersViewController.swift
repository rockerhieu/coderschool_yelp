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

    var filters: Filters?
    var isDistanceExpanded = false
    var isSortByExpanded = false

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
            filters = Filters()
        }
    }

    @IBAction func onSearchClicked(sender: AnyObject) {
        delegate?.filtersViewController?(self, didUpdateFilters: filters!)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters)
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return isDistanceExpanded ? filters?.distanceFilters.count ?? 0 : 1
        case 2: return isSortByExpanded ? filters?.sortByFilters.count ?? 0 : 1
        case 3: return filters?.categoryFilters.count ?? 0
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
            cell.data = (name: "Offering a Deal", value: filters?.isOfferingADeal ?? false)
            cell.isOfferingADeal = true
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("RadioCell", forIndexPath: indexPath) as! RadioCell
            let distanceFilter = filters?.selectedDistanceFilter
            cell.checkView.font = UIFont.fontAwesomeOfSize(30)
            if isDistanceExpanded {
                cell.nameView.text = filters?.distanceFilters[indexPath.row].text
                cell.checkView.text = String.fontAwesomeIconWithName(distanceFilter?.distance == filters?.distanceFilters[indexPath.row].distance ? FontAwesome.Check : FontAwesome.CircleO)
            } else {
                cell.nameView.text = distanceFilter?.text
                cell.checkView.text = String.fontAwesomeIconWithName(FontAwesome.AngleDown)
            }

            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("RadioCell", forIndexPath: indexPath) as! RadioCell
            cell.checkView.font = UIFont.fontAwesomeOfSize(30)
            let sortBy = filters?.sortByFilters[indexPath.row]
            let selectedSortBy = filters?.selectedSortByFilter
            if isSortByExpanded {
                cell.nameView.text = sortBy?.text
                cell.checkView.text = String.fontAwesomeIconWithName(selectedSortBy == sortBy ? FontAwesome.Check : FontAwesome.CircleO)
            } else {
                cell.nameView.text = selectedSortBy?.text
                cell.checkView.text = String.fontAwesomeIconWithName(FontAwesome.AngleDown)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.isOfferingADeal = false
            cell.delegate = self
            let category = filters?.categoryFilters[indexPath.row]
            cell.data = (name: category!.name, value: category!.checked)
            return cell
        }
    }
    
    func switchCell(cell: SwitchCell, didChangeValue value: Bool) {
        if cell.isOfferingADeal {
            filters?.isOfferingADeal = value
        } else {
            let indexPath = tableView.indexPathForCell(cell)
            filters?.categoryFilters[indexPath!.row].checked = value
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:break
        case 1:
            if isDistanceExpanded {
                filters?.selectedDistanceFilter = filters?.distanceFilters[indexPath.row]
            }
            isDistanceExpanded = !isDistanceExpanded
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            break
        case 2:
            if isSortByExpanded {
                filters?.selectedSortByFilter = filters?.sortByFilters[indexPath.row]
            }
            isSortByExpanded = !isSortByExpanded
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            break
        case 3:break
        default:break
        }
    }
}