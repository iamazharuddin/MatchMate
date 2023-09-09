//
//  ApiManager.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
enum ApiError : Error {
     case invalidUrl(String)
     case networkError(String)
     case noData(String)
     case inValidData(String)
}


class ApiManager{
    static let shared = ApiManager()
    func fetchUserData() async throws -> [User] {
        guard let url = URL(string: "https://randomuser.me/api/?results=10") else {
            throw URLError(_nsError: NSError())
        }
        let urlRequest = URLRequest(url: url)
        do {
            let (data, _) =  try await URLSession.shared.data(for: urlRequest)
            print(String(data: data, encoding: .utf8)!)
            do {
                let usersResponse = try  JSONDecoder().decode(UserResponse.self, from: data)
                return usersResponse.results!
            } catch let error {
                print(error.localizedDescription)
                throw error
            }
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}
