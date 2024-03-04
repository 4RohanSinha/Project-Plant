//
//  PhotographyView.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit

class PhotographyView: UIView {

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var photoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
    }
    func configureWithImage(image: UIImage) {
        imageView?.image = image
        photoLbl.isHidden = true
    }
    
}
