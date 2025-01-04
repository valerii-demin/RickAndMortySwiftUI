//
//  Repository.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import Foundation

protocol RepositoryProtocol {
    func getData(for url: URL) async throws -> Data
    func getList() async throws -> [Item]
    func getItem(for id: Int) async throws -> Item
}

class Repository: RepositoryProtocol {
    
    static let shared: RepositoryProtocol = Repository(networkService: NetworkService())
    
    private let networkService: NetworkServiceProtocol
    private var nextPageUrl = URL(string: EndPoint.base + EndPoint.list)
    
    private var data: [URL: Data] = [:]
    private var list: [URL?: [Item]] = [:]
    private var item: [Int: Item] = [:]
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getData(for url: URL) async throws -> Data {
        guard let cachedData = data[url] else {
            return try await networkService.getData(for: url)
        }
        return cachedData
    }
    
    func getList() async throws -> [Item] {
        guard let cachedData = list[nextPageUrl] else {
            guard let url = nextPageUrl else { return [] }
            let dto = try await networkService.getList(for: url)
            nextPageUrl = dto.info.next
            list[url] = dto.results.map(Item.init)
            return list[url] ?? []
        }
        return cachedData
    }
    
    func getItem(for id: Int) async throws -> Item {
        guard let cachedData = item[id] else {
            guard let url = URL(string: EndPoint.base + EndPoint.item + String(id)) else {
                throw NetworkError.requestError
            }
            let dto = try await networkService.getItem(for: url)
            let model = Item(dto)
            item[id] = model
            return model
        }
        return cachedData
    }
}

private extension Item {
    init(_ dto: ItemDTO) {
        id = dto.id
        name = dto.name
        episode = dto.episode
        url = dto.url
        airDate = dto.air_date
    }
}
