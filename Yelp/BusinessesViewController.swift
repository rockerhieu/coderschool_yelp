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
    var filters: [String: AnyObject]?
    
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
        let categories = filters?["Category"] as? Categories
        var selectedCategories = [String]()
        if let categoriesData = categories?.data {
            for category in categoriesData {
                if category.checked {
                    selectedCategories.append(category.code)
                }
            }
        }
        
        let term = searchController.searchBar.text ?? ""
        let sortRawValue = filters?["Sort By"] as? Int
        let sort = YelpSortMode(rawValue: sortRawValue ?? 1)
        let deals = filters?["Offering a Deal"] as? Bool
        Business.searchWithTerm(term, sort: sort, categories: selectedCategories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
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