//
//  ApiService.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation

class ApiService : NSObject {
    private let baseUrl = ""
    
    private let sourcesURL = URL(string: "https://api.restful-api.dev/objects")!
    
    func fetchDeviceDetails(completion : @escaping (Result<[DeviceData], APIError>) -> ()){
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.networkError)) // Return an empty array on network failure
                return
            }
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode([DeviceData].self, from: data)
                if (empData.isEmpty) {
                    completion(.failure(.decodeError))
                } else {
                    // Once data is successfully loaded store the same in UserDefaults.
                    if let encoded = try? JSONEncoder().encode(empData) {
                        UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.networkFailure.rawValue)
                    }
                    completion(.success(empData))
                }
            } else {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}


enum APIError: Error {
    case invalidData
    case decodeError
    case networkError
}


enum UserDefaultsKeys: String {
    case networkFailure
}
