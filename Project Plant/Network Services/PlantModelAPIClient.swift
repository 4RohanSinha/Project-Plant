//
//  PlantModelAPIHandler.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import Foundation

class PlantModelAPIClient {
    enum Endpoints {
        static let plantModelBase = "http://127.0.0.1:5000/"
        static let diagnosisEnd = "treatment"
        static let searchEnd = "search"
        
        case diagnosis
        case search
        
        private var urlStringVal: String {
            switch self {
            case let .diagnosis:
                return Endpoints.plantModelBase + Endpoints.diagnosisEnd
            case let .search:
                return Endpoints.plantModelBase + Endpoints.searchEnd
            }
        }
        
        var url: URL {
            return URL(string: urlStringVal)!
        }
    }
    
    class func createDiagnosisRequest(plant_photo: Data) -> DiagnosisRequest {
        return DiagnosisRequest(plant_photo: plant_photo)
    }
    
    class func getSearchResults(query: String, completion: @escaping (SearchResultResponse?, Error?) -> Void) -> URLSessionTask? {
        let req = SearchRequest(query: query)
        
        let task = postRequest(url: Endpoints.search.url, requestData: req, completion: completion)
        
        return task
    }
    
    class func postRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestData: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask? {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONEncoder().encode(requestData)
        } catch {
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard let data = data else {
                if let error = err {
                    completion(nil, error)
                }
                
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
        
        return task
    }
    
    class func getDiagnosis(requestData: DiagnosisRequest, completion: @escaping (DiagnosisResponse?, Error?) -> Void) {
        postRequest(url: Endpoints.diagnosis.url, requestData: requestData, completion: completion)
    }
}
