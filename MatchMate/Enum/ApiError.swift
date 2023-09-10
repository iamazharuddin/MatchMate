//
//  ApiError.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 10/09/23.
//

import Foundation
enum ApiError : LocalizedError {
     case invalidURL
     case serverError
     case inValidData
     case unkown(Error)
     var  errorDescription: String?{
        switch self{
        case .invalidURL:
             return "The URL was invalid, Please try again later."
        case .serverError:
            return "There was an error with server, Please try again later."
        case .inValidData:
            return "The user data is invalid, Please try again later."
        case .unkown(let error):
            return error.localizedDescription
        }
    }
}
