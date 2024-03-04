//
//  PlantCreatorViewController.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit

class PlantCreatorViewController: CoreDataStackViewController {

    var result: SearchResult?
    @IBOutlet weak var plantNameField: UITextField!
    @IBOutlet weak var imageViewerPicker: PhotographyView!
    @IBOutlet weak var plantCapturedImage: UIImageView!
    @IBOutlet weak var plantType: UILabel!
    
    @IBOutlet weak var savePlantBtn: UIButton!
    var newPlant: Plant?
    
    func configureWithResult(dataController_: DataController, res: SearchResult) {
        dataController = dataController_
        result = res
        guard let dataController = dataController else { return }
        newPlant = Plant(context: dataController.viewContext)
        newPlant?.type = result?.plant_name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantType.text = result?.plant_name ?? ""
        savePlantBtn.layer.cornerRadius = 5.0
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
    
    @IBAction func uploadRoll(_ sender: Any) {
        let albumImagePicker = createImagePicker(sourceType: .photoLibrary)
        present(albumImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveNewPlant(_ sender: Any) {
        guard let newPlant = newPlant, let dataController = dataController, let imgData = plantCapturedImage?.image?.pngData(), plantNameField.text != "" else {
            
            
            let alertVC = UIAlertController(title: "Error", message: "Missing fields.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel) {_ in
                alertVC.dismiss(animated: true)
            }
            
            alertVC.addAction(alertAction)
            
            present(alertVC, animated: true)
            return
        }

        newPlant.name = plantNameField.text
        
        let newImage = PlantPhoto(context: dataController.viewContext)
        newImage.photo = imgData
        newImage.photoId = 0
        newPlant.addToPhotos(newImage)
        newPlant.currentHealth = HEALTH.randomElement() ?? "healthy"
        newPlant.recommendation = RECOMMENDATIONS.randomElement() ?? ""
        //newPlant.recommendation =
        try? dataController.viewContext.save()
       
        dismiss(animated: true) {
            //self.navigationController?.popViewController(animated: true)
            self.navigationController?.tabBarController?.selectedIndex = 0
        }
    }
    
}

extension PlantCreatorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            imageViewerPicker.configureWithImage(image: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
