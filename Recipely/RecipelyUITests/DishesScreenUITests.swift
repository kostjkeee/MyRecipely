// DishesScreenUITests.swift

import XCTest

final class DishesScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

        let emailTextField = app.textFields[" Enter Email Address"]
        XCTAssert(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("qwe@mail.ru")

        let passwordTextField = app.textFields["Enter Password"]
        XCTAssert(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("123")

        let loginButton = app.buttons["Login"]
        XCTAssert(loginButton.exists)
        loginButton.tap()
        sleep(2)
        app.collectionViews.staticTexts["Chicken"].tap()
        sleep(3)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSwipeTableView() {
        let tableView = app.tables.firstMatch
        tableView.swipeUp()
        tableView.swipeDown()
    }

    func testSearchField() {
        let searchField = app.descendants(matching: .searchField).firstMatch
        XCTAssertTrue(searchField.exists, "There is no search field on CategoryDishes screen")

        let tableView = app.tables.firstMatch
        searchField.tap()
        searchField.typeText("asdfasdf")
        XCTAssertTrue(tableView.cells.count != 0, "Showing table on incorrect search query")

        searchField.buttons.firstMatch.tap()
    }
}
