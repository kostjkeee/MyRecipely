// DishesDetailScreenUITests.swift

import XCTest

final class DishesDetailScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
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
        let chickenCategory = app.collectionViews.staticTexts["Chicken"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: chickenCategory)
        waitForExpectations(timeout: 5)
        chickenCategory.tap()
        let myTableView = app.tables[Local.DishesTableView.accessibilityIdentifier]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: myTableView)
        waitForExpectations(timeout: 5)
        let cell = myTableView.cells.element(boundBy: 0)
        XCTAssert(cell.exists)
        cell.tap()
        sleep(2)
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other)
        XCTAssert(element.element.exists)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testBackButton() {
        let detailsBackButton = app.buttons[Local.DishesDetailsBackButton.accessibilityIdentifier]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: detailsBackButton)
        waitForExpectations(timeout: 5)
        XCTAssertTrue(detailsBackButton.exists)

        detailsBackButton.tap()
        sleep(1)
    }

    func testShareButton() {
        let shareButton = app.buttons[Local.ShareButton.accessibilityIdentifier]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: shareButton)
        waitForExpectations(timeout: 10)
        XCTAssertTrue(shareButton.exists)

        shareButton.tap()
        sleep(3)
    }

    func testAddToFavoriteButton() {
        let addToFavoritesButton = app.buttons[Local.AddFavoritesButton.accessibilityIdentifier]
        XCTAssertTrue(addToFavoritesButton.exists)

        addToFavoritesButton.tap()
        sleep(1)
        addToFavoritesButton.tap()
    }

    func testSwipeForTableView() {
        let myTableView = app.tables[Local.DishesDetailTableView.accessibilityIdentifier]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: myTableView)
        waitForExpectations(timeout: 5)
        myTableView.swipeUp()
        myTableView.swipeDown()
    }
}
