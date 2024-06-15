// CategoryScreenUITests.swift

import XCTest

final class CategoryScreenUITests: XCTestCase {
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
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testTapCell() throws {
        let cells = app.collectionViews.cells
        cells.otherElements.containing(.image, identifier: "salad").element.tap()
        let backButton = app.navigationBars["Recipely.RecepeCategoryView"].buttons["arrow"]
        XCTAssertTrue(backButton.exists, "There is no back button on CategoriesScreen")
        backButton.tap()
    }

    func testScrollCollectionView() {
        let verticalScrollBar2PagesCollectionView = app.collectionViews.containing(
            .other,
            identifier: "Horizontal scroll bar, 1 page"
        ).element
        verticalScrollBar2PagesCollectionView.swipeUp()
        verticalScrollBar2PagesCollectionView.swipeDown()
    }

    func testTabBar() {
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Favorites"].tap()

        let favoritesStaticText = XCUIApplication().staticTexts["Favorites"]
        XCTAssertTrue(favoritesStaticText.exists)

        tabBar.buttons["Profile"].tap()

        let profileStaticText = XCUIApplication().staticTexts["Profile"]
        XCTAssertTrue(profileStaticText.exists)

        tabBar.buttons["Recipes"].tap()
        let recipesStaticText = XCUIApplication().staticTexts["Recipes"]
        XCTAssert(recipesStaticText.exists)
    }
}
