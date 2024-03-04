//
//  PlantModelAPIHandler.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import Foundation

class PlantModelAPIClient {
    enum Endpoints {
        static let plantModelBase = ""
        static let diagnosisEnd = ""
        static let recommenderEnd = ""
        static let searchEnd = ""
        
        case diagnosis
        case recommender
        
        private var urlStringVal: String {
            switch self {
            case let .diagnosis:
                return Endpoints.plantModelBase + Endpoints.diagnosisEnd
            case let .recommender:
                return Endpoints.plantModelBase + Endpoints.recommenderEnd
            }
        }
        
        var url: URL {
            return URL(string: urlStringVal)!
        }
    }
    
    class func createDiagnosisRequest(plant_photo: Data) -> DiagnosisRequest {
        return DiagnosisRequest(plant_photo: plant_photo)
    }
    
    class func createRecommenderRequest() -> RecommenderRequest {
        return RecommenderRequest(plants: [])
    }
    
    class func postRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestData: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONEncoder().encode(requestData)
        } catch {
            return
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
    }
    
    class func getDiagnosis(requestData: DiagnosisRequest, completion: @escaping (DiagnosisResponse?, Error?) -> Void) {
        postRequest(url: Endpoints.diagnosis.url, requestData: requestData, completion: completion)
    }
    
    class func getRecommendation(requestData: RecommenderRequest, completion: @escaping (RecommenderResponse?, Error?) -> Void) {
        postRequest(url: Endpoints.recommender.url, requestData: requestData, completion: completion)
    }
}
