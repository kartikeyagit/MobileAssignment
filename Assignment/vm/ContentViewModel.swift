//
//  ContentViewModel.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation


class ContentViewModel : ObservableObject {
    
    private let apiService = ApiService()
    @Published var navigateDetail: DeviceData? = nil
    @Published var data: [DeviceData]? = []

    func fetchAPI(completion : @escaping (Result<[DeviceData], APIError>) -> ()) {
        apiService.fetchDeviceDetails(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let item):
                    self.data = item
                    completion(.success(item))
                case .failure(let failure):
                    if failure == .networkError {
                        // Retrieve from UserDefaults
                        if let data = UserDefaults.standard.object(forKey: UserDefaultsKeys.networkFailure.rawValue) as? Data,
                           let devicesData = try? JSONDecoder().decode([DeviceData].self, from: data) {
                            self.data = devicesData
                        }
                    }
                    completion(.failure(failure))
                }
            }
        })
    }
    
    func navigateToDetail(navigateDetail: DeviceData) {
        self.navigateDetail = navigateDetail
    }
}

