//
//  DetailView.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: ItemViewModel
    
    init(id: Int) {
        _viewModel = StateObject(wrappedValue: ItemViewModel(id: id))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading data...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack(alignment: .leading) {
                    Text(viewModel.name ?? "")
                        .font(.headline)
                        .bold()
                    Text(viewModel.episode ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(viewModel.airDate ?? "")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .navigationTitle("Item \(viewModel.id)")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .task {
            await viewModel.fetchData()
        }
    }
}
