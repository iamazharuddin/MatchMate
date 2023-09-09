//
//  CardViewModel.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
struct CardViewModel {
    private let user : User
    let handleUserAction : (UserStatus) -> Void
    let userStatus : UserStatus
    init(user: User, handleUserAction: @escaping (UserStatus) -> Void) {
        self.user = user
        self.handleUserAction = handleUserAction
        self.userStatus = user.userStatus
    }
    
    var fullName : String  {
        return user.name.first  + " " + (user.name.last ?? "")
    }
    var completeAddress: String {
        let location = user.location
        let streetAddress = "\(location.street?.number ?? 0) \(location.street?.name ?? "")"
        return "\(streetAddress), \(location.city ?? ""), \(location.state ?? ""), \(location.country ?? ""), \(location.postalCode ?? "")"
    }
    
    var profileImageUrl : String {
        return user.picture.large ?? user.picture.medium ?? ""
    }
}
