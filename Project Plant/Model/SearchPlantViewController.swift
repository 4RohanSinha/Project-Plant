//
//  RecommendationViewController.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit

let MAX_SET = [SearchResult(plant_name: "Aloe vera", watering_level: "average"), SearchResult(plant_name: "Chinese Money Plant", watering_level: "frequent"),  SearchResult(plant_name: "Jade plant", watering_level: "none"), SearchResult(plant_name: "Spider plant", watering_level: "frequent"), SearchResult(plant_name: "Fiddle-leaf fig", watering_level: "none"), SearchResult(plant_name: "Snake plant", watering_level: "frequent"), SearchResult(plant_name: "Moth orchid", watering_level: "frequent"), SearchResult(plant_name: "Rubber plant", watering_level: "frequent")]

let HEALTH: [String] = ["healthy", "healthy", "healthy", "scab concerns", "mildew concerns"]
let RECOMMENDATIONS: [String] = ["Isolation: Remove the infected plant from other healthy plants to prevent the spread of the disease.", "Pruning: Trim away any infected leaves using clean, sharp scissors. Dispose of the infected plant material in the trash, not compost.", "Reduce Humidity: Rust diseases thrive in humid conditions. Ensure good air circulation around the plant and avoid overwatering to reduce humidity levels.", "Fungicide Treatment: Apply a fungicide labeled for use on rust diseases. Follow the instructions carefully, and reapply as necessary according to the product label.", "Remove Fallen Leaves: Rust spores can survive on fallen leaves. Remove any fallen leaves from the soil around the plant and dispose of them properly.", "Monitor and Prevent: Keep a close eye on your aloe vera plant for any signs of rust disease. Preventative fungicide treatments may be necessary if the disease is a recurring problem.", "Improve Growing Conditions: Ensure that your aloe vera plant is receiving proper care, including adequate sunlight, well-draining soil, and proper watering practices."]

class SearchPlanViewController: CoreDataStackViewController {

    @IBOutlet weak var recommendationTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var introMsg: UILabel!
    var results: [SearchResult] = []
    
    var task: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        results = MAX_SET
        //results = [SearchResult(plant_name: "Aloe vera", watering_level: "average"), SearchResult(plant_name: "Chinese Money Plant", watering_level: "frequent"),  SearchResult(plant_name: "Jade plant", watering_level: "none"), SearchResult(plant_name: "Spider plant", watering_level: "frequent"), SearchResult(plant_name: "Fiddle-leaf fig", watering_level: "none"), SearchResult(plant_name: "Snake plant", watering_level: "frequent"), SearchResult(plant_name: "Moth orchid", watering_level: "frequent"), SearchResult(plant_name: "Rubber plant", watering_level: "frequent")]
        
        
        recommendationTableView.dataSource = self
        recommendationTableView.delegate = self
    }
    
    func getSearchResults() {
        
        results = MAX_SET.filter({ res in
            if let txt = searchBar.text {
                return res.plant_name.lowercased().contains(txt.lowercased())
            }
            
            return false
        })
        
        recommendationTableView.reloadData()
        
        if (results.count == 0) {
            introMsg.isHidden = false
        } else {
            introMsg.isHidden = true
        }
        //results.append(contentsOf: results)
        /*task?.cancel()
        task = PlantModelAPIClient.getSearchResults(query: searchBar.text ?? "") { res, err in
            if let res = res {
                self.results = res.results
                print(self.results)
                DispatchQueue.main.async {
                    self.recommendationTableView.reloadData()
                }
            }
        }*/
    }

    @IBAction func updateSearchResult(_ sender: Any) {
        getSearchResults()
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
        if let nextVC = segue.destination as? PlantCreatorViewController, let sender = sender as? SearchResult, let dataController = dataController {
            nextVC.configureWithResult(dataController_: dataController, res: sender)
        }
        
    }
}

extension SearchPlanViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as? SearchResultTableCell {
            cell.configureWithResult(res: results[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addPlant", sender: results[indexPath.row])
    }
}
