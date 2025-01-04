//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    @Published var items: [Item] = []
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol = Repository.shared) {
        self.repository = repository
    }
    
    @MainActor
    func fetchData() async {
        do {
            items += try await repository.getList()
            errorMessage = nil
        } catch {
            errorMessage = "Cannot load the data"
        }
        isLoading = false
    }
}
