//
//  RecommenderRequest.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import Foundation

struct RecommenderRequest: Codable {
    let plants: [RecommenderPlantInput]
}

struct RecommenderPlantInput: Codable {
    let type: String
    let status: String
}
