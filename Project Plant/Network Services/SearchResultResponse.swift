//
//  SearchResult.swift
//  Project Plant
//
//  Created by Rohan Sinha on 3/3/24.
//

import Foundation

struct SearchResultResponse: Codable {
    var results: [SearchResult]
}

struct SearchResult: Codable {
    var plant_name: String
    var watering_level: String
}
