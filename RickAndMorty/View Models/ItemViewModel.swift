//
//  ItemViewModel.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import Foundation

class ItemViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    @Published var id: Int
    @Published var name: String?
    @Published var episode: String?
    @Published var airDate: String?    
    
    private let repository: RepositoryProtocol
    init(id: Int, repository: RepositoryProtocol = Repository.shared) {
        self.id = id
        self.repository = repository
    }
    
    @MainActor
    func fetchData () async {
        do {
            let item = try await repository.getItem(for: id)
            name = item.name
            episode = item.episode
            airDate = item.airDate
            errorMessage = nil
        } catch {
            errorMessage = "Cannot load the data"
        }
        isLoading = false
    }
}
