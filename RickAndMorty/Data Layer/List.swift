//
//  List.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import Foundation

struct ListDTO: Codable {
    let results: [ItemDTO]
    let info: InfoDTO
    
    struct InfoDTO: Codable {
        let next: URL?
    }
}
