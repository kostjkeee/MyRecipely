// NetworkServiceTests.swift

import CoreData
import UIKit
import XCTest

final class NetworkServiceTests: XCTestCase {
    var networService: NetworkServiceProtocol!

    override func setUpWithError() throws {
        networService = NetworkService()
    }

    override func tearDownWithError() throws {
        networService = nil
    }

    func testGetRecipes() {
        let expectation = XCTestExpectation(description: "waiting")
        let category: RecipeCategories = .fish
        let search: String? = ""
        let complitionHandler: (Result<[RecipeCard], Error>) -> Void = { result in
            switch result {
            case let .success(recipes) where !recipes.isEmpty:
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            default:
                XCTFail("result is empty")
                expectation.fulfill()
            }
        }
        networService.getRecipes(category: category, search: search, complitionHandler: complitionHandler)
        wait(for: [expectation])
    }

    func testGetRecipesWithSearch() {
        let expectation = XCTestExpectation(description: "waiting")
        let category: RecipeCategories = .fish
        let search: String? = "fish"
        let complitionHandler: (Result<[RecipeCard], Error>) -> Void = { result in
            switch result {
            case let .success(recipes) where !recipes.isEmpty:
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            default:
                XCTFail("result is empty")
                expectation.fulfill()
            }
        }
        networService.getRecipes(category: category, search: search, complitionHandler: complitionHandler)
        wait(for: [expectation])
    }

    func testGetRecipesDetails() {
        let expectation = XCTestExpectation(description: "waiting")
        let uri = "http://www.edamam.com/ontologies/edamam.owl#recipe_7bf4a371c6884d809682a72808da7dc2"

        let complitionHandler: (Result<RecipeDetails, Error>) -> Void = { result in
            switch result {
            case let .success(recipeDetails) where recipeDetails.label == "Teriyaki Chicken":
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            default:
                XCTFail("result is damaged")
                expectation.fulfill()
            }
        }
        networService.getDetail(uri: uri, complitionHandler: complitionHandler)
        wait(for: [expectation])
    }
}
