//
//  RecommendationViewController.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import UIKit

class SearchPlanViewController: UIViewController {

    @IBOutlet weak var recommendationTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    var results: [SearchResult] = []
    
    var task: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        results = [SearchResult(plant_name: "test", watering_level: "average")]
        recommendationTableView.dataSource = self
        recommendationTableView.delegate = self
    }
    
    func getSearchResults() {
        results.append(contentsOf: results)
        recommendationTableView.reloadData()
    }

    @IBAction func updateSearchResult(_ sender: Any) {
        task?.cancel()
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
}
