//
//  UserCardViewModel.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
struct UserCardViewModel {
    private let user : User
    let handleUserAction : (UserStatus) -> Void
    let userStatus : UserStatus
    init(user: User, handleUserAction: @escaping (UserStatus) -> Void) {
        self.user = user
        self.handleUserAction = handleUserAction
        self.userStatus = user.userStatus
    }
    
    var fullName : String  {
        let nameComponents: [String?] = [user.name.title, user.name.first, user.name.last]
        let fullName = nameComponents.compactMap { $0 }.joined(separator: " ")
        return fullName
    }
    
    var completeAddress: String {
        let location = user.location
        var addressComponents: [String] = []

        if let streetNumber = location.street?.number {
            addressComponents.append("\(streetNumber)")
        }

        if let streetName = location.street?.name {
            addressComponents.append(streetName)
        }

        if let city = location.city {
            addressComponents.append(city)
        }

        if let state = location.state {
            addressComponents.append(state)
        }

        if let country = location.country {
            addressComponents.append(country)
        }

        if let postalCode = location.postalCode {
            addressComponents.append(postalCode)
        }

        return addressComponents.joined(separator: ", ")
    }

    
    var profileImageUrl : String {
        return user.picture.large ?? user.picture.medium ?? ""
    }
}
