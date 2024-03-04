//
//  PlantGalleryViewController.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit
import CoreData

class PlantGalleryViewController: CoreDataStackViewController {

    //view elements
    //gallery, type of plant, plant name, current health
    
    var plant: Plant!
    var photosFetchedResultsController: NSFetchedResultsController<PlantPhoto>?
    
    
    @IBOutlet weak var plantGalleryCollection: UICollectionView!
    @IBOutlet weak var PlantType: UITextField!
    @IBOutlet weak var PlantName: UITextField!
    @IBOutlet weak var PlantHealth: UITextField!
    
    var blocksForCollection: [BlockOperation] = [] //necessary for updating the collection view

    func configureVC(dataController: DataController, plant: Plant) {
        self.dataController = dataController
        self.plant = plant
    }
    
    func initFetchedResultsController() {
        
        guard let dataController = dataController else { return }
        let photosFetchRequest = PlantPhoto.fetchRequest()
        photosFetchRequest.predicate = NSPredicate(format: "plant == %@", plant)
        let photosSortDescriptor = NSSortDescriptor(key: "photoId", ascending: true)
        photosFetchRequest.sortDescriptors = [photosSortDescriptor]
        
        photosFetchedResultsController = NSFetchedResultsController(fetchRequest: photosFetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        photosFetchedResultsController?.delegate = self
        
        do {
            try photosFetchedResultsController?.performFetch()
        } catch {
            print("Error fetching plants")
        }
        
    }
    
    func setTextToPlantData() {
        PlantType.text = plant.type
        PlantName.text = plant.name
        PlantHealth.text = plant.currentHealth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextToPlantData()
        plantGalleryCollection.dataSource = self
        plantGalleryCollection.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        photosFetchedResultsController?.delegate = nil
        photosFetchedResultsController = nil
    }
    
    func createImagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let cameraImagePicker = createImagePicker(sourceType: .camera)
        present(cameraImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        let albumImagePicker = createImagePicker(sourceType: .photoLibrary)
        present(albumImagePicker, animated: true, completion: nil)
    }
    
    
}

extension PlantGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)

        if let dataController = dataController, let image = info[.originalImage] as? UIImage {
            let newPhoto = PlantPhoto(context: dataController.viewContext)
            newPhoto.photo = image.pngData()
            newPhoto.photoId = Int32(plant.photos?.count ?? 0)
            plant.addToPhotos(newPhoto)
            try? dataController.viewContext.save()
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PlantGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photosFetchedResultsController?.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print(photosFetchedResultsController?.object(at: indexPath).photo)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plantGalleryCell", for: indexPath) as? GalleryPhotoCell, let imgData = photosFetchedResultsController?.object(at: indexPath).photo {
            cell.imageView?.image = UIImage(data: imgData)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension PlantGalleryViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        plantGalleryCollection .performBatchUpdates {
            for operation in blocksForCollection {
                operation.start()
            }
        } completion: { (finished) in
            self.blocksForCollection.removeAll(keepingCapacity: false)
        }
        

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            blocksForCollection.append(BlockOperation(block: {
                self.plantGalleryCollection.insertItems(at: [newIndexPath!])
            }))
        case .delete:
            blocksForCollection.append(BlockOperation(block: {
                self.plantGalleryCollection.deleteItems(at: [indexPath!])
            }))
        case .update:
            blocksForCollection.append(BlockOperation(block: {
                self.plantGalleryCollection.reloadItems(at: [indexPath!])
            }))
        case .move:
            blocksForCollection.append(BlockOperation(block: {
                self.plantGalleryCollection.moveItem(at: indexPath!, to: newIndexPath!)
            }))
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert: plantGalleryCollection.insertSections(indexSet)
        case .delete: plantGalleryCollection.deleteSections(indexSet)
        case .update, .move: break //these operations aren't possible
        default: break
        }
    }
}
