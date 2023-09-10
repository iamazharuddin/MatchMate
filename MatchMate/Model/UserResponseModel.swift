//
//  UserResponseModel.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
struct UserResponse : Decodable {
    let results : [User]
}

struct User : Decodable, Identifiable {
    var id : String { return email }
    let name : Name
    let email : String
    let gender : String
    let picture : Picture
    let location : Location
    var userStatus : UserStatus = .none
    enum CodingKeys: String, CodingKey {
           case name,gender, picture, location, email
    }
}

struct Name : Decodable {
    let title : String?
    let first:String
    let last:String?
}


struct Picture : Decodable {
      let medium : String?
      let large : String?
}

struct Location : Decodable {
    let street : Street?
    let city : String?
    let state : String?
    let country: String?
    let postalCode : String?
}

struct Street : Decodable {
    let number : Int?
    let name : String?
}
