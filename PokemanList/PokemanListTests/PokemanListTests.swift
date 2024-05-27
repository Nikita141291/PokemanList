//
//  PokemanListTests.swift
//  PokemanListTests
//
//  Created by Nikita on 27/05/24.
//

import XCTest
@testable import PokemanList

final class PokemanListTests: XCTestCase {

    var pokemonListViewModel: PokemonListViewModel!
    
    override func setUp() {
            super.setUp()
            // Initialize your view model or any dependencies needed for fetching and displaying Pokémon
            pokemonListViewModel = PokemonListViewModel()
        }
        
        override func tearDown() {
            // Clean up after each test if needed
            pokemonListViewModel = nil
            super.tearDown()
        }
        
        func testFetchPokemonList() {
            // Expectation for async call completion
            let expectation = XCTestExpectation(description: "Fetch Pokémon list")
            
            // Perform the fetch operation
            PokemonService.shared.fetchPokemonList(limit: 100, offset: 0) { result in
                switch result {
                case .success(let pokemonList):
                    // Assert that the fetched list contains 100 Pokémon
                    XCTAssertEqual(pokemonList.results.count, 100, "Expected 100 Pokémon, but got \(pokemonList.results.count)")
                    
                    // You can perform more specific assertions here if needed
                    // For example, check if the first Pokémon in the list has a valid name or ID
                    
                    // Fulfill the expectation indicating the async call is completed
                    expectation.fulfill()
                    
                case .failure(let error):
                    // If the fetch fails, fail the test
                    XCTFail("Failed to fetch Pokémon list with error: \(error.localizedDescription)")
                }
            }
            
            // Wait for the expectation to be fulfilled, or timeout after a certain time
            wait(for: [expectation], timeout: 5.0) // Adjust the timeout value as needed
        }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
