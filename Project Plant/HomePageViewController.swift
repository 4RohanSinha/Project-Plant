//
//  HomePageViewController.swift
//  Project Plant
//
//  Created by Lindsay Qin on 3/3/24.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var FactLabel: UILabel!

    @IBAction func MyPlantsOnButtonClick(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    @IBAction func RecommendationsOnButtonClick(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FactLabel.text = getFact()
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

func getFact() -> String {
    let x = Int.random(in: 1..<11)
    
    switch x {
    case 1:
            return "A study by NASA shows that indoor houseplants actually purify the air."
    case 2:
        return "People who work in an environment surrounded by plants feel more relaxed and have lower blood pressure. Studies show that having plants is a great boost for comfort and remaining focused."
    case 3:
            return "Plants and flowers can actually speed up recovery, be it from injury, surgery or an illness. Alongside that, the patient would typically require less pain medication and shorter hospital stays."
    case 4:
            return "Studies show that students surrounded by plants had improvements in their attention and concentration. Houseplants increase focus, attention and creativity."
    case 5: return "House plants actually reduce low and high frequencies. Those noisy neighbors won’t know what’s hit them."
    case 6: return "Houseplant diseases can spread. When using pruners, clippers or trowels, make sure to clean them with rubbing alcohol before you use them on another plant."
    case 7: return "Whilst not actually allergic, the dust on your plant's leaves can actually stop them photosynthesize. All you need to do is get a small damp cloth and give their leaves a wipe once a month, and voila!"
    case 8: return "Did you know that plants love music? We all know that having houseplants can be a relaxing and tranquil experience, but sometimes a little music goes a long way."
    case 9: return "The reason why most houseplants are from the tropical regions of the world is that they are used to growing under canopies in the shade. That’s why they are so well suited to growing inside your home."
    default: return "Science now shows that plants actually talk to each other. They generally do this via their roots or even by letting out chemicals into their soil."
    }

}
