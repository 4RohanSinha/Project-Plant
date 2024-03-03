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
    @IBOutlet weak var plantNameTextLabel: UILabel!
    @IBOutlet weak var recommendationTextField: UITextField!
    
    var plantsFetchedResultsController: NSFetchedResultsController<Plant>?
    
    func initFetchedResultsController() {
        
        guard let dataController = dataController else { return }
        
        let plantsFetchRequest = Plant.fetchRequest()
        let plantSortDescriptor = NSSortDescriptor(key: "plantId", ascending: true)
        plantsFetchRequest.sortDescriptors = [plantSortDescriptor]
        
        plantsFetchedResultsController = NSFetchedResultsController(fetchRequest: plantsFetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        plantsFetchedResultsController?.delegate = self
        
        do {
            try plantsFetchedResultsController?.performFetch()
        } catch {
            print("Error fetching plants")
        }
    }
    
    func deinitFetchedResultsController() {
        plantsFetchedResultsController?.delegate = nil
        plantsFetchedResultsController = nil
    }
    
    func setPageControlView() {
        imageViewPageControl.numberOfPages = plantsFetchedResultsController?.sections?[0].numberOfObjects ?? 0
    }
    
    func setImageView() {
        guard let plantsFetchedResultsController = plantsFetchedResultsController, let currentPhotos = plantsFetchedResultsController.object(at: IndexPath(row: imageViewPageControl.currentPage, section: 0)).photos?.allObjects as? [Data], !currentPhotos.isEmpty else { return }
       
        plantImageView.image = UIImage(data: currentPhotos[currentPhotos.count-1])

    }
    
    func alignViews() {
        setPageControlView()
        setImageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initFetchedResultsController()
        
        alignViews()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deinitFetchedResultsController()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyPlantsViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        alignViews()
    }
}
