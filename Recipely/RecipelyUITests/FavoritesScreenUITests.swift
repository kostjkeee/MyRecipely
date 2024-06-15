// FavoritesScreenUITests.swift

import XCTest

final class FavoritesScreenUITests: XCTestCase {
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
        sleep(3)
        app.collectionViews.staticTexts["Chicken"].tap()
        sleep(1)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAddToFavoriteButton() {
        // находим tableView для экрана блюд
        let recipesDishesTableView = app.tables[Local.DishesTableView.accessibilityIdentifier]
        XCTAssertTrue(recipesDishesTableView.exists)

        // нажимаем на первую ячейку
        let cell = recipesDishesTableView.cells.element(boundBy: 0)
        cell.tap()
        sleep(1)

        // добавляем блюдо в избранное
        let addToFavoritesButton = app.buttons[Local.AddFavoritesButton.accessibilityIdentifier]
        XCTAssertTrue(addToFavoritesButton.exists)
        addToFavoritesButton.tap()
        sleep(1)

        // переходим назад в экран блюд
        let detailsBackButton = app.buttons[Local.DishesDetailsBackButton.accessibilityIdentifier]
        XCTAssertTrue(detailsBackButton.exists)
        detailsBackButton.tap()
        sleep(1)

        // переходим назад в экран категорий
        let recipesBackButton = app.buttons[Local.DishesBackButton.accessibilityIdentifier]
        XCTAssertTrue(recipesBackButton.exists)
        recipesBackButton.tap()
        sleep(1)

        // переходим в tabBar Favorites
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        let favoritesTab = tabBar.buttons[Local.FavoritesTab.accessibilityIdentifier]
        favoritesTab.tap()
        sleep(1)

        // проверяем на swipe наш tableView
        let favoritesTableView = app.tables[Local.FavoritesTableView.accessibilityIdentifier]
        favoritesTableView.swipeUp()
        favoritesTableView.swipeDown()
    }

    func testRemoveFromFavoriteButton() {
        // возвращаемся в экран категорий
        let recipesBackButton = app.buttons[Local.DishesBackButton.accessibilityIdentifier]
        XCTAssertTrue(recipesBackButton.exists)
        recipesBackButton.tap()
        sleep(1)

        // находим tabBar в приложении
        let myTabBar = app.tabBars.firstMatch
        XCTAssert(myTabBar.exists)

        // заходим в tabBar favorites
        let favoritesTabBar = myTabBar.buttons[Local.FavoritesTab.accessibilityIdentifier]
        XCTAssert(favoritesTabBar.exists)
        favoritesTabBar.tap()
        sleep(1)

        // находим tableView
        let favoritesTableView = app.tables[Local.FavoritesTableView.accessibilityIdentifier]
        XCTAssert(favoritesTableView.exists)
        let cell = favoritesTableView.cells.element(boundBy: 0)
        cell.swipeLeft()

        // Поиск кнопки "Delete" по лейблу
        let deleteButton = cell.buttons["Delete"]

        // Проверяем, существует ли кнопка
        XCTAssert(deleteButton.exists)

        // Нажимаем на кнопку
        deleteButton.tap()
    }
}
