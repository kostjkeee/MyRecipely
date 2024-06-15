// ProfileScreenUITests.swift

import XCTest

final class ProfileScreenUITests: XCTestCase {
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

        let tabBar = app.tabBars.firstMatch
        let profileTab = tabBar.buttons[Local.ProfileTab.accessibilityIdentifier]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: profileTab)
        waitForExpectations(timeout: 5)
        XCTAssert(profileTab.exists)
        profileTab.tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testChangeProfileName() {
        let profileTableView = app.tables[Local.ProfileTableView.accessibilityIdentifier]
        XCTAssert(profileTableView.exists)
        let cell = profileTableView.cells.element(boundBy: 0)
        XCTAssert(cell.exists)
        let changeButton = cell.buttons[Local.Profile.ChangeNameButton.accessibilityIdentifier]
        XCTAssert(changeButton.exists)
        changeButton.tap()
        sleep(1)

        // находим наш алерт
        let changeNameAlert = app.alerts.firstMatch
        XCTAssert(changeNameAlert.exists)
        let textField = changeNameAlert.textFields.element(boundBy: 0)
        textField.tap()
        textField.typeText("Levon krasava")

        let okButton = changeNameAlert.buttons.element(boundBy: 1)
        okButton.tap()
    }

    func testShowBonusesScreen() {
        let profileTableView = app.tables[Local.ProfileTableView.accessibilityIdentifier]
        XCTAssert(profileTableView.exists)
        let cell = profileTableView.cells.element(boundBy: 1)
        XCTAssert(cell.exists)
        let openBonusesButton = cell.buttons.firstMatch
        XCTAssert(openBonusesButton.exists)
        openBonusesButton.tap()
        sleep(1)

        let bonusesView = app.otherElements[Local.Profile.BonusesView.accessibilityIdentifier]
        XCTAssert(bonusesView.exists)

        let bonusesDismissButton = app.buttons[Local.Profile.BonusesView.DismissButton.accessibilityIdentifier]
        XCTAssert(bonusesDismissButton.exists)
        bonusesDismissButton.tap()
    }

    func testShowPrivacyPolicyScreen() {
        let profileTableView = app.tables[Local.ProfileTableView.accessibilityIdentifier]
        XCTAssert(profileTableView.exists)
        let cell = profileTableView.cells.element(boundBy: 2)
        XCTAssert(cell.exists)
        let openPrivacyPolicyButton = cell.buttons.firstMatch
        XCTAssert(openPrivacyPolicyButton.exists)
        openPrivacyPolicyButton.tap()
        sleep(1)

        let privacyPolicyView = app.otherElements[Local.Profile.PrivacyView.accessibilityIdentifier]
        XCTAssert(privacyPolicyView.exists)

        let privacyPolicyDismissButton = app.buttons[Local.Profile.PrivacyView.DismissButton.accessibilityIdentifier]
        XCTAssert(privacyPolicyDismissButton.exists)
        privacyPolicyDismissButton.tap()
    }

    func testLogOutAlert() {
        let profileTableView = app.tables[Local.ProfileTableView.accessibilityIdentifier]
        XCTAssert(profileTableView.exists)
        let cell = profileTableView.cells.element(boundBy: 3)
        XCTAssert(cell.exists)
        let showLogOutAlert = cell.buttons.firstMatch
        XCTAssert(showLogOutAlert.exists)
        showLogOutAlert.tap()
        sleep(1)

        let logOutAlert = app.alerts.firstMatch
        XCTAssert(logOutAlert.exists)

        let closeButton = logOutAlert.buttons.element(boundBy: 0)
        closeButton.tap()

        showLogOutAlert.tap()
        sleep(1)

        let okButton = logOutAlert.buttons.element(boundBy: 1)
        okButton.tap()
    }
}
