//
//  PlantGalleryViewController.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit

class PlantGalleryViewController: UIViewController {

    //view elements
    //gallery, type of plant, plant name, current health
    
    var plant: Plant!
    
    func configurePlant(plant_: Plant) {
        plant = plant_
    }
    
    @IBOutlet weak var PlantType: UITextField!
    @IBOutlet weak var PlantName: UITextField!
    @IBOutlet weak var PlantHealth: UITextField!
    
    func setTextToPlantData() {
        PlantType.text = plant.type
        PlantName.text = plant.name
        PlantHealth.text = plant.currentHealth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextToPlantData()
    }
    
}

extension PlantGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
