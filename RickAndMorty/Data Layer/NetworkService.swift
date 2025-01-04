//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData(for url: URL) async throws -> Data
    func getList(for url: URL) async throws -> ListDTO
    func getItem(for url: URL) async throws -> ItemDTO
}

class NetworkService: NetworkServiceProtocol {
    private let decoder: JSONDecoder = .init()
    
    func getData(for url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }
        return data
    }
    
    func getList(for url: URL) async throws -> ListDTO {
        let data = try await getData(for: url)
        return try decoder.decode(ListDTO.self, from: data)
    }
    
    func getItem(for url: URL)async throws  -> ItemDTO {
        let data = try await getData(for: url)
        return try decoder.decode(ItemDTO.self, from: data)
    }
}

enum NetworkError: Error {
    case requestError
    case serverError
}
