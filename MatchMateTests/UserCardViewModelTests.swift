//
//  UserCardViewModelTests.swift
//  MatchMateTests
//
//  Created by Azharuddin 1 on 10/09/23.
//

import XCTest
@testable import MatchMate

class UserCardViewModelTests: XCTestCase {
    
    var viewModel: UserCardViewModel!
    var userStatus : UserStatus = .none

      override func setUp() {
          super.setUp()
          let name = Name(title: nil, first: "Cory", last: "Russell")
          let location = Location(street: Street(number: 1615, name: "Dublin Road"), city: "Athenry", state: "Galway City", country: "Ireland", postalCode: "32179")
          let user = User( name:name, email: "cory.russell@example.com", gender: "male", picture: Picture(medium: nil, large: nil), location: location, userStatus: userStatus)
           viewModel = UserCardViewModel(user: user) { [weak self] status in
               self?.userStatus = status
          }
      }
      
      override func tearDown() {
          viewModel = nil
          super.tearDown()
      }
    
    func testFullName() {
        // Given (viewModel is already set up)
                
        // When
        let fullName = viewModel.fullName
        
        // Then
        XCTAssertEqual(fullName, "Cory Russell")
    }
    
    
    func testCompleteAddress() {
        // Given (viewModel is already set up)
                
        // When
        let completeAddress = viewModel.completeAddress
        
        // Then
        XCTAssertEqual(completeAddress, "1615, Dublin Road, Athenry, Galway City, Ireland, 32179")
    }
    
    
    func testHandleUserAction() {
        // Given (viewModel is already set up)
        
        // When
        viewModel.handleUserAction(UserStatus.accepted)
        
        // Then
        XCTAssertEqual(userStatus, UserStatus.accepted)
    }
}
