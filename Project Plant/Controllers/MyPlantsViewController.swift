//
//  MyPlantsViewController.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit
import CoreData

class MyPlantsViewController: CoreDataStackViewController {

    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var imageViewPageControl: UIPageControl!
    @IBOutlet weak var plantNameTextLabel: UITextField!
    @IBOutlet weak var viewStatsBtn: UIButton!
    @IBOutlet weak var addPlantBtn: UIButton!
    @IBOutlet weak var recommendationTextField: UITextView!
    
    var plantsFetchedResultsController: NSFetchedResultsController<Plant>?
    
    func initFetchedResultsController() {
        print("TEST")
        guard let dataController = dataController else { return }
        print("TEST 2")
        let plantsFetchRequest = Plant.fetchRequest()
        let plantSortDescriptor = NSSortDescriptor(key: "plantId", ascending: true)
        plantsFetchRequest.sortDescriptors = [plantSortDescriptor]
        
        plantsFetchedResultsController = NSFetchedResultsController(fetchRequest: plantsFetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        plantsFetchedResultsController?.delegate = self
        
        do {
            try plantsFetchedResultsController?.performFetch()
            print(plantsFetchedResultsController?.fetchedObjects?.count)
            imageViewPageControl.numberOfPages = plantsFetchedResultsController?.fetchedObjects?.count ?? 1
        } catch {
            print("Error fetching plants")
        }
        
    }
    
    func deinitFetchedResultsController() {
        plantsFetchedResultsController?.delegate = nil
        plantsFetchedResultsController = nil
    }
    
    @IBAction func seeDetailedPlantView(_ sender: Any) {
    }
    
    
    func setPageControlView() {
        if (plantsFetchedResultsController?.fetchedObjects?.count == 0) {
            viewStatsBtn.isHidden = true
            addPlantBtn.isHidden = false
        } else {
            viewStatsBtn.isHidden = false
            addPlantBtn.isHidden = true
        }
        
        imageViewPageControl.numberOfPages = plantsFetchedResultsController?.sections?[0].numberOfObjects ?? 0
    }
    
    func setImageView() {
        guard let dataController = dataController, let plantsFetchedResultsController = plantsFetchedResultsController, let currentPlants = plantsFetchedResultsController.fetchedObjects else { return }
        
        if currentPlants.count < 1 {
            return
        }
        
        
        guard let currentPhotos = currentPlants[imageViewPageControl.currentPage].photos?.allObjects as? [PlantPhoto] else { return }
        if currentPhotos.count < 1 {
            return
        }
        
        plantNameTextLabel.text = currentPlants[imageViewPageControl.currentPage].name
        
        recommendationTextField.text = currentPlants[imageViewPageControl.currentPage].recommendation
        
        guard let imgData = currentPhotos[currentPhotos.count-1].photo else { return }
        
        
        if let photoData = currentPhotos[currentPhotos.count-1].photo {
            plantImageView.image = UIImage(data: imgData)
        }

    }
    
    func alignViews() {
        setPageControlView()
        setImageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarController?.selectedIndex = 1
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initFetchedResultsController()
        
        alignViews()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deinitFetchedResultsController()
    }

    @IBAction func seePlantDetail(_ sender: Any) {
        performSegue(withIdentifier: "seePlantDetail", sender: IndexPath(row: imageViewPageControl.currentPage, section: 0))
    }
    
    @IBAction func addPlantScreen(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    
    @IBAction func changePageControlValue(_ sender: Any) {
        alignViews()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let galleryVC = segue.destination as? PlantGalleryViewController, let dataController = dataController, let indexPath = sender as? IndexPath, let plant = plantsFetchedResultsController?.object(at: indexPath) {
            galleryVC.configureVC(dataController: dataController, plant: plant)
        }
    }

}

extension MyPlantsViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        alignViews()
    }
}
