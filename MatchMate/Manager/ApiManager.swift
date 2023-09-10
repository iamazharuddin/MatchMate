//
//  ApiManager.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
protocol ApiManagerDelegate {
    func fetchUserData() async throws -> [User]
}

class ApiManager : ApiManagerDelegate {
    static let shared = ApiManager()
    func fetchUserData() async throws -> [User] {
        do {
            let urlString =  AppURLConstant.baseURL + "?results=10"
            guard let url = URL(string:urlString) else {
                throw ApiError.invalidURL
            }
            let urlRequest = URLRequest(url: url)
            let (data, response) =  try await URLSession.shared.data(for: urlRequest)
            guard  (response as? HTTPURLResponse)?.statusCode == 200 else { throw ApiError.serverError }
            guard let usersResponse = try?  JSONDecoder().decode(UserResponse.self, from: data) else {  throw ApiError.inValidData }
            return usersResponse.results
        } catch {
            throw ApiError.unkown(error)
        }
    }
}
