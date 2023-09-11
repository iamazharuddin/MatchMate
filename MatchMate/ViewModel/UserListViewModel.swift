//
//  UserListViewModel.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import Foundation
enum UserStatus  : String {
    case accepted = "accepted"
    case rejected = "rejected"
    case none = "none"
}

class UserListViewModel : ObservableObject {
    @Published var users : [User] = []
    @Published var isLoading : Bool = false
    @Published var alertDescription: AlertDescription?
    
    private let apiManager : ApiManagerDelegate
    
    init(apiManager:ApiManagerDelegate = ApiManager()) {
        self.apiManager = apiManager
    }
        
    func  fetchUserData(){
        if NetworkMonitor.shared.isReachable{
            fetchUserFromApi()
        }else{
            fetchUserFromLocalDatabase()
        }
    }
    
    
    func handleUserAction(userStatus: UserStatus,  user : User){
        if let index = users.firstIndex(where: { $0.email == user.email }) {
            var modifiedUser = user
            modifiedUser.userStatus = userStatus
            users[index] = modifiedUser
            do {
                try DatabaseManager.shared.updateUserInDatabase(user: modifiedUser)
            } catch  {
                self.alertDescription = AlertDescription(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Perform API call
extension UserListViewModel {
    private func fetchUserFromApi(){
        print("from api")
        isLoading = true
        Task {
            do {
                let users = try await apiManager.fetchUserData()
                DispatchQueue.main.async { [weak self] in
                    self?.users = users
                    self?.isLoading = false
                    self?.performDatabaseOperation()
                }
            } catch let error as ApiError{
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.alertDescription = AlertDescription(message: error.errorDescription ?? "Unknown Error" )
                }
            }
        }
    }
}

// MARK: - Perform Database operation
extension UserListViewModel{
    private func performDatabaseOperation(){
        do {
            try  DatabaseManager.shared.deleteAllUsersFromDatabase()
            DatabaseManager.shared.saveUsersToDatabase(users: users){  result in
                switch result{
                case .success:
                     print("Saved to local databse succesfully.")
                case .failure(let error):
                     DispatchQueue.main.async {
                         self.alertDescription = AlertDescription(message: error.localizedDescription)
                    }
                }
            }
        } catch  {
            DispatchQueue.main.async {
                self.alertDescription = AlertDescription(message: error.localizedDescription)
           }
        }
    }
    
    
    private func fetchUserFromLocalDatabase(){
        print("From local database")
        isLoading = true
        DatabaseManager.shared.fetchUserDataFromDatabase{[weak self] result in
          switch result{
          case .success(let users):
              self?.users = users
              self?.isLoading = false
          case .failure(let error):
              print(error.localizedDescription)
              self?.alertDescription = AlertDescription(message: error.localizedDescription)
          }
      }
    }
}
