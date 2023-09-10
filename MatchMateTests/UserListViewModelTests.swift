//
//  UserListViewModelTests.swift
//  MatchMateTests
//
//  Created by Azharuddin 1 on 10/09/23.
//

import XCTest
@testable import MatchMate
class UserListViewModelTests: XCTestCase {
    var viewModel: UserViewModel!

    override func setUp() {
        super.setUp()
        viewModel = UserViewModel(apiManager : MockApiManager())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchUserData() {
        // Given (viewModel is already set up with the mock API manager)
        
        // When
        viewModel.fetchUserData()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        
        let expectation = expectation(description: "FetchUserDataExpectation")
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.viewModel.isLoading = false
            XCTAssertFalse(self.viewModel.isLoading)
            
            XCTAssertEqual(self.viewModel.users.count, 3)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}


class MockApiManager: ApiManagerDelegate {
    func fetchUserData() async throws -> [User] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user1 = User(
            name: Name(title: "Mr", first: "John", last: "Doe"),
            email: "john.doe@example.com",
            gender: "male",
            picture: Picture(medium: "john_medium.jpg", large: "john_large.jpg"),
            location: Location(
                street: Street(number: 123, name: "Main St"),
                city: "New York",
                state: "NY",
                country: "USA",
                postalCode: "10001"
            ),
            userStatus: .none
        )

        let user2 = User(
            name: Name(title: "Ms", first: "Jane", last: "Smith"),
            email: "jane.smith@example.com",
            gender: "female",
            picture: Picture(medium: "jane_medium.jpg", large: "jane_large.jpg"),
            location: Location(
                street: Street(number: 456, name: "Elm St"),
                city: "Los Angeles",
                state: "CA",
                country: "USA",
                postalCode: "90001"
            ),
            userStatus: .none
        )

        let user3 = User(
            name: Name(title: "Dr", first: "David", last: "Johnson"),
            email: "david.johnson@example.com",
            gender: "male",
            picture: Picture(medium: "david_medium.jpg", large: "david_large.jpg"),
            location: Location(
                street: Street(number: 789, name: "Oak St"),
                city: "Chicago",
                state: "IL",
                country: "USA",
                postalCode: "60601"
            ),
            userStatus: .none
        )

        return [user1, user2, user3]
    }
}
