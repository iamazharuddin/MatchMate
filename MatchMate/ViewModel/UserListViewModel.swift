//
//  UserListViewModel.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
import CoreData

enum UserStatus {
    case accepted
    case rejected
    case none
}

class UserViewModel : ObservableObject {
    @Published var users : [User] = []
    @Published var isLoading : Bool = false
    @Published var isAccepted : Bool = false
    @Published var isRejected : Bool = false
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    func  fetchUserData(){
        isLoading = true
        Task {
            do {
                let users = try await ApiManager.shared.fetchUserData()
                DispatchQueue.main.async { [weak self] in
                    self?.users = users
                    self?.isLoading = false
                }
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                }
            }
        }
    }
    
    func handleUserAction(userStatus: UserStatus,  user : User){
        if let index = users.firstIndex(where: { $0.uuid == user.uuid }) {
            var modifiedUser = user
            modifiedUser.userStatus = userStatus
            users[index] = modifiedUser
        }
    }
    

     func saveUserToDatabase(user: User) {
         let userEntity = UserEntity(context: managedObjectContext)
         userEntity.first = user.name.first
         userEntity.last = user.name.last
         userEntity.gender = user.gender
         do {
             try managedObjectContext.save()
         } catch {
             print("Error saving user data: \(error)")
         }
     }
}
