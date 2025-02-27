//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path
    @State private var searchText: String = ""
    @State private var isNetworkError: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                VStack {
                    TextField("Search Text", text: $searchText)
                        .padding(.horizontal)
                        .font(.system(size: 14, weight: .medium))
                    
                    let filteredData = viewModel.data?.filter({
                        $0.name.localizedCaseInsensitiveContains(searchText) ||
                        $0.data?.capacity?.localizedCaseInsensitiveContains(searchText) ?? false ||
                        $0.data?.color?.localizedCaseInsensitiveContains(searchText) ?? false
                    })
                    
                    if let computers = searchText.isEmpty ? viewModel.data : filteredData, !computers.isEmpty {
                        DevicesList(devices: computers) { selectedComputer in
                            viewModel.navigateToDetail(navigateDetail: selectedComputer)
                        }
                        
                        if isNetworkError {
                            Text("Offline Cached Data")
                                .font(.headline)
                                .padding(.vertical)
                        }
                    } else {
                        if !searchText.isEmpty {
                            Text("No result found")
                                .font(.system(size: 16, weight: .medium))
                                .padding(.vertical)
                        } else {
                            ProgressView("Loading...")
                        }
                    }
                    Spacer()
                }
            }
            .onChange(of: viewModel.navigateDetail, {
                let navigate = viewModel.navigateDetail
                path.append(navigate!)
            })
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .onAppear {
                // Handle result operations for isLoading/isError accordingly.
                isNetworkError = false // reset
                viewModel.fetchAPI { result in
                    switch result {
                    case .success(_):
                        navigationAction()
                    case .failure(let failure):
                        if failure == .networkError {
                            self.isNetworkError = true
                            navigationAction()
                        }
                    }
                }
            }
        }
    }
    
    func navigationAction() {
        let navigate = viewModel.navigateDetail
        if (navigate != nil) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                path.append(navigate!)
            }
        }
    }
}
