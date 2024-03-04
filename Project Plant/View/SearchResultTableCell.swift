//
//  SearchResultTableCell.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit
//none/minimum, average, frequent
class SearchResultTableCell: UITableViewCell {
    @IBOutlet weak var plantNameLabel: UITextField!
    @IBOutlet weak var droplet1: UIImageView!
    @IBOutlet weak var droplet2: UIImageView!
    @IBOutlet weak var droplet3: UIImageView!
    
    func configureWithResult(res: SearchResult) {
        plantNameLabel.text = res.plant_name
        
        droplet1.isHidden = false
        
        
    }
}
