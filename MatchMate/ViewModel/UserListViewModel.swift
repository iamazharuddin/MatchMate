//
//  UserListViewModel.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
import CoreData

enum UserStatus  : String {
    case accepted = "accepted"
    case rejected = "rejected"
    case none = "none"
}

class UserViewModel : ObservableObject {
    @Published var users : [User] = []
    @Published var isLoading : Bool = false
    @Published var isAccepted : Bool = false
    @Published var isRejected : Bool = false
    func  fetchUserData(){
        let users = DatabaseManager.shared.fetchUserDataFromDatabase()
        if users.count > 0 {
            print("from local database")
            self.users = users
        }else {
            isLoading = true
            print("from api call")
            Task {
                do {
                    let users = try await ApiManager.shared.fetchUserData()
                    DispatchQueue.main.async { [weak self] in
                        self?.users = users
                        self?.isLoading = false
                        DatabaseManager.shared.deleteAllUsersFromDatabase()
                        for user in users{
                            DatabaseManager.shared.saveUserToDatabase(user: user)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                    DispatchQueue.main.async { [weak self] in
                        self?.isLoading = false
                    }
                }
            }
        }
    }
    
    func handleUserAction(userStatus: UserStatus,  user : User){
        for u in users{
            print(u.email)
            
            print("matches", user.email == u.email)
            if  user.email == u.email{
                break
            }
        }
        if let index = users.firstIndex(where: { $0.email == user.email }) {
            var modifiedUser = user
            modifiedUser.userStatus = userStatus
            users[index] = modifiedUser
            DatabaseManager.shared.updateUserInDatabase(user: modifiedUser)
        }
    }
}
