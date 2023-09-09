//
//  ApiManager.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation

struct AppURLConstant{
    static let baseURL = "https://randomuser.me/api/"
}

enum ApiError : LocalizedError {
     case networkError(String)
     case noData(String)
     case inValidData
}


class ApiManager{
    static let shared = ApiManager()
    func fetchUserData() async throws -> [User] {
        guard let url = URL(string: AppURLConstant.baseURL + "?results=10") else {
            throw URLError(.badURL)
        }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, _) =  try await URLSession.shared.data(for: urlRequest)
            do {
                let usersResponse = try  JSONDecoder().decode(UserResponse.self, from: data)
                return usersResponse.results!
            } catch let error {
                print(error.localizedDescription)
                throw ApiError.inValidData
            }
        } catch let error {
            print(error.localizedDescription)
            throw ApiError.noData(error.localizedDescription)
        }
    }
}
