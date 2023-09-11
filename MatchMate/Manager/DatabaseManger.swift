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
    
    // MARK: - Fetch User Data from Database
    func fetchUserDataFromDatabase(completion: @escaping (Result<[User], Error>) -> Void) {
        PersistenceController.shared.container.performBackgroundTask { backgroundContext in
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            do {
                let userEntities = try backgroundContext.fetch(fetchRequest)
                let users = userEntities.map { userEntity in
                    let name = Name(title: userEntity.title,  first: userEntity.first ?? "", last: userEntity.last ?? "")
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    // MARK: - Save User to Database
    func saveUsersToDatabase(users: [User], completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var saveError: Error?

        PersistenceController.shared.container.performBackgroundTask { privateManagedContext in
            for user in users {
                dispatchGroup.enter() // Enter the dispatch group for each user

                let userEntity = UserEntity(context: privateManagedContext)
                userEntity.email = user.email
                userEntity.title = user.name.title
                userEntity.first = user.name.first
                userEntity.last = user.name.last
                userEntity.gender = user.gender
                userEntity.userStatus = user.userStatus.rawValue
                userEntity.streetName = user.location.street?.name ?? ""
                userEntity.streetNumber = Int32(user.location.street?.number ?? 0)
                userEntity.city = user.location.city ?? ""
                userEntity.country = user.location.country ?? ""
                userEntity.profileImageUrl = user.picture.large ?? user.picture.medium ?? ""

                do {
                    try privateManagedContext.save()
                } catch {
                    saveError = error
                }

                dispatchGroup.leave() // Leave the dispatch group when each user is saved
            }

            dispatchGroup.notify(queue: .main) {
                if let error = saveError {
                    completion(.failure(error))
                } else {
                    completion(.success(Void()))
                }
            }
        }
    }


    // MARK: - Update User in Database
    func updateUserInDatabase(user: User) throws {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", user.email)
        do {
            let fetchedUsers = try managedObjectContext.fetch(fetchRequest)
            if let userEntityToUpdate = fetchedUsers.first {
                userEntityToUpdate.userStatus = user.userStatus.rawValue
            }
            try managedObjectContext.save()
        } catch  {
            throw error
        }
    }
    
    
    // MARK: - Delete All Users from Database
    func deleteAllUsersFromDatabase() throws  {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            throw error
        }
    }
    
    func syncDataToServer(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement data synchronization logic here
    }
}
