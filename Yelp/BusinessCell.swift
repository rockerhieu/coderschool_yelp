//
//  BusinessCell.swift
//  Yelp
//
//  Created by Hieu Rocker on 3/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var reviewsView: UILabel!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var distanceView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var categoriesView: UILabel!
    
    var business: Business! {
        didSet {
            photoView.image = nil
            if let photoImageUrl = business.imageURL {
                photoView.setImageWithURL(photoImageUrl)
            }
            nameView.text = business.name
            reviewsView.text = "\(business.reviewCount ?? 0) Reviews"
            ratingView.image = nil
            if let ratingImageUrl = business.ratingImageURL {
                ratingView.setImageWithURL(ratingImageUrl)
            }
            distanceView.text = business.distance
            addressView.text = business.address
            categoriesView.text = business.categories
        }
    }
}
