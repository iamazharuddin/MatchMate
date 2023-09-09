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
    @Published var alertDescription: AlertDescription?
    func  fetchUserData(){
        isLoading = true
        DatabaseManager.shared.fetchUserDataFromDatabase{[weak self] result in
            switch result{
            case .success(let users):
                self?.users = users
                self?.isLoading = false
                if users.isEmpty{
                    self?.fetchUserFromApi()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.alertDescription = AlertDescription(message: error.localizedDescription)
                self?.fetchUserFromApi()
            }
        }
    }
    
    
    private func fetchUserFromApi(){
        print("from api")
        isLoading = true
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
                    self?.alertDescription = AlertDescription(message: error.localizedDescription)
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
