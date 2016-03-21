//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]?
    var searchController: UISearchController!
    var filters: Filters?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchBar()
        doSearch()
    }
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        automaticallyAdjustsScrollViewInsets = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    
    @IBAction func onFilterClicked(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let filtersViewController = storyboard.instantiateViewControllerWithIdentifier("FilterVC") as! FiltersViewController
        filtersViewController.delegate = self
        filtersViewController.filters = filters
        presentViewController(filtersViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func backMainScreen(segue: UIStoryboardSegue) {
        segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let term = searchController.searchBar.text ?? ""
        Business.searchWithTerm(term, sort: filters?.selectedSortByFilter.sortMode,
            categories: filters?.selectedCategories,
            deals: filters?.isOfferingADeal) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses?.filter { business in
                let distanceInMeters = self.filters?.selectedDistanceFilter.distanceInMeters
                if (distanceInMeters == 0) {
                    return true
                }
                return business.distanceMeters?.doubleValue <= distanceInMeters
            }
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters) {
        self.filters = filters
        doSearch()
    }
}


extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses![indexPath.row]
        return cell
    }
}

extension BusinessesViewController: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        self.performSelector("doSearch", withObject:nil, afterDelay: 0.5)
    }
}