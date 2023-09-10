//
//  DatabaseManger.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 09/09/23.
//

import Foundation
import CoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    private init() {} 
    
    // MARK: - Save User to Database
    func saveUserToDatabase(user: User) {
        let userEntity = UserEntity(context: managedObjectContext)
        userEntity.uuid = user.uuid
        userEntity.email = user.email
        userEntity.first = user.name.first
        userEntity.last = user.name.last
        userEntity.gender = user.gender
        userEntity.userStatus = user.userStatus.rawValue
        userEntity.streetName  = user.location.street?.name ?? ""
        userEntity.streetNumber = Int32(user.location.street?.number ?? 0)
        userEntity.city = user.location.city ?? ""
        userEntity.country = user.location.country ?? ""
        userEntity.profileImageUrl = user.picture.large  ?? user.picture.medium ?? ""
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving user data: \(error)")
        }
    }
    
    // MARK: - Update User in Database
    
    func updateUserInDatabase(user: User) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", user.email)
        do {
            let fetchedUsers = try managedObjectContext.fetch(fetchRequest)
            if let userEntityToUpdate = fetchedUsers.first {
                userEntityToUpdate.userStatus = user.userStatus.rawValue
            }
            try managedObjectContext.save()
        } catch  {
            print("Error updating user data in Core Data: \(error)")
        }
    }
    
    // MARK: - Fetch User Data from Database
    func fetchUserDataFromDatabase(completion: @escaping (Result<[User], Error>) -> Void ) {
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            
            do {
                let userEntities = try backgroundContext.fetch(fetchRequest)
                let users = userEntities.map { userEntity in
                    let name = Name(first: userEntity.first ?? "", last: userEntity.last ?? "")
                    let location = Location(street: Street(number: Int(userEntity.streetNumber), name: userEntity.streetName),
                                            city: userEntity.city ?? "",
                                            state: "",
                                            country: userEntity.country ?? "",
                                            postalCode: "")
                    let picture = Picture(medium: userEntity.profileImageUrl, large: userEntity.profileImageUrl)
                    
                    return User(
                        name: name,
                        email: userEntity.email ?? "",
                        gender: userEntity.gender ?? "",
                        picture: picture,
                        location: location,
                        userStatus: UserStatus(rawValue: userEntity.userStatus ?? "none") ?? UserStatus.none
                    )
                }
                
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                print("Error fetching user data from Core Data: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    
    // MARK: - Delete All Users from Database
    func deleteAllUsersFromDatabase() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            print("Error deleting all users from Core Data: \(error)")
        }
    }
    
    func syncDataToServer(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement data synchronization logic here
    }
}
