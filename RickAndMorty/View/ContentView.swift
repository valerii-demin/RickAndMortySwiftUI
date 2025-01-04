//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Valerii Demin on 1/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel = ListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading data ...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.items) { item in
                        NavigationLink(destination: DetailView(id: item.id)) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.episode)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .onAppear {
                                if item == viewModel.items.last {
                                    Task {
                                        await viewModel.fetchData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("List")
            .task {
                await viewModel.fetchData()
            }
        }
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    ContentView()
}
