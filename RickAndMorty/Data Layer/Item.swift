//
//  Item.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import Foundation

struct ItemDTO: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [URL]
    let url: URL
    let created: String
}

struct Item: Identifiable {
    let id: Int
    let name: String
    let episode: String
    let url: URL
    let airDate: String
}
