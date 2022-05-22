//
//  BusinessLogicUnitTests.swift
//  FransiSRentalHouseProjectUITests
//
//  Created by Kuan on 2022/5/16.
//

import XCTest

class BusinessLogicUnitTests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = true
    }
    
//    override func tearDownWithError() throws {
//        app = XCUIApplication()
//        let profileButton = app.buttons["TapProfileButton"]
//        XCTAssertTrue(profileButton.exists)
//        profileButton.tap()
//        let menuButton = app.buttons["menuButton"]
//        XCTAssertTrue(menuButton.exists)
//        menuButton.tap()
//        let settingTitle = app.staticTexts["setting"]
//        XCTAssertTrue(settingTitle.exists)
//        XCTAssertEqual(settingTitle.label, "Setting")
//        let signOutButton = app.buttons["signOut"]
//        XCTAssertTrue(signOutButton.exists)
//        signOutButton.tap()
//    }

}


class app_business_logic_test: BusinessLogicUnitTests {

    func test_user_login(userName: String, password: String) {
       
        let userNameTextField = app.textFields["userName"]
        userNameTextField.tap()
        userNameTextField.typeText(userName)
        userNameTextField.tap()
        let passwordTextField = app.secureTextFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)
        passwordTextField.tap()
        let loginButton = app.buttons["signIn"]
        XCTAssert(loginButton.waitForExistence(timeout: 1))
        loginButton.tap()
        let announcement = app.staticTexts["announcement"]
        XCTAssertEqual(announcement.label, "Announcement")
    }
    
    func test_user_sign_out() {
        let profileButton = app.buttons["TapProfileButton"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        let menuButton = app.buttons["menuButton"]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        let settingTitle = app.staticTexts["setting"]
        XCTAssertTrue(settingTitle.exists)
        XCTAssertEqual(settingTitle.label, "Setting")
        let signOutButton = app.buttons["signOut"]
        XCTAssertTrue(signOutButton.exists)
        signOutButton.tap()
    }
    
    private func checkButtonExitAndTap(acesID: String) {
        let button = app.buttons[acesID]
        XCTAssertTrue(button.exists)
        XCTAssert(button.waitForExistence(timeout: 1))
        button.tap()
    }
    
    private func checkTextExit(acesID: String) {
        let text = app.staticTexts[acesID]
        XCTAssertTrue(text.exists)
    }
    
    
    func test_user_buying_product_process() {
        let testingUserName = "testuser@test.con"
        let testingPassword = "123123"
        test_user_login(userName: testingUserName, password: testingPassword)
        let toggleButtonTitle = app.staticTexts["presentTitle"]
        XCTAssertTrue(toggleButtonTitle.exists)
        let toggleButton = app.switches["presentSwitch"]
        XCTAssertTrue(toggleButton.exists)
        toggleButton.tap()
        checkButtonExitAndTap(acesID: "testProduct")
        checkButtonExitAndTap(acesID: "appCart")
        let prepurchase = app.buttons["TapPaymentButton"]
        prepurchase.tap()
        let subtotal = app.staticTexts["subTotal"]
        XCTAssertNotEqual(subtotal.label, "0")
        checkButtonExitAndTap(acesID: "checkOut")
        checkButtonExitAndTap(acesID: "Ship to Store")
        checkButtonExitAndTap(acesID: "tosAgree")
        checkButtonExitAndTap(acesID: "confrim")
        checkButtonExitAndTap(acesID: "pay")
        checkButtonExitAndTap(acesID: "TapProfileButton")
        checkButtonExitAndTap(acesID: "menuButton")
        checkTextExit(acesID: "setting")
        checkButtonExitAndTap(acesID: "ordered")
        checkTextExit(acesID: "orderID")
        let naviBackButton = app.navigationBars.buttons.element
        XCTAssert(naviBackButton.exists)
        naviBackButton.tap()
        checkButtonExitAndTap(acesID: "signOut")
    }
    
    func test_product_provider_getting_order_list() {
        let testUserName = "testp@test.com"
        let testPassword = "112233"
        test_user_login(userName: testUserName, password: testPassword)
        checkButtonExitAndTap(acesID: "FixButton")
        checkTextExit(acesID: "shippingList")
        checkButtonExitAndTap(acesID: "updateState")
        checkButtonExitAndTap(acesID: "showList")
        let listSheet = app.staticTexts["orderAmount"]
        listSheet.scrolling(direction: .scrollDown)
        test_user_sign_out()
    }
    
    private func textFieldAndTyping(textID: String, typeText: String) {
        let textField = app.textFields[textID]
        textField.tap()
        textField.typeText(typeText)
        textField.tap()
    }
    
    func test_product_provider_summit_new_product() {
//        let message = "Product's Information is waiting to summit, if you want to adjust something, please press cancel, else press okay to continue"
        let testUserName = "testp@test.com"
        let testPassword = "321321A!"
        test_user_login(userName: testUserName, password: testPassword)
        checkButtonExitAndTap(acesID: "TapPaymentButton")
        checkButtonExitAndTap(acesID: "phpicker")
        let phpView = app.otherElements["Photos"].scrollViews.otherElements
        phpView.images["Photo, August 09, 2012, 5:29 AM"].tap()
        phpView.images["Photo, August 09, 2012, 5:55 AM"].tap()
        phpView.images["Photo, August 09, 2012, 2:52 AM"].tap()
        let addButton = app.navigationBars["Photos"].buttons["Add"]
        addButton.tap()
        let pickerSection = app.scrollViews.otherElements.buttons["pickerSection"]
        pickerSection.tap()
        let pickerItem = app.collectionViews.cells.buttons["一般電子"]
        pickerItem.tap()
        textFieldAndTyping(textID: "productName", typeText: "test product2")
        textFieldAndTyping(textID: "price", typeText: "321")
        textFieldAndTyping(textID: "amount", typeText: "50")
        textFieldAndTyping(textID: "from", typeText: "Taiwan")
        let textEditor = app.scrollViews.textViews["productDes"]
        textEditor.tap()
        textEditor.typeText("test description 2")
        let tosButton = app.scrollViews.otherElements.buttons["tosAgree"]
        tosButton.tap()
        let summitButton = app.scrollViews.otherElements.buttons["summitButton"]
        summitButton.tap()
//        let alertMessage = app.alerts.staticTexts["alertMessage"]
//        XCTAssertTrue(alertMessage.waitForExistence(timeout: 1))
        let okayButton = app.buttons["okay"]
        okayButton.tap()
        let processView = app.staticTexts["process"]
        XCTAssertFalse(processView.waitForExistence(timeout: 5))
        test_user_sign_out()
    }
    
    
    private func scrollText(acesID: String, contain: String) {
        let textField = app.scrollViews.otherElements.textFields[acesID]
        textField.tap()
        textField.typeText(contain)
//        textField.tap()
    }
    
    private func scrollButton(acesID: String) {
        let button = app.scrollViews.buttons[acesID]
        button.tap()
    }
    
    private func photoSelected(phName: String) {
        let img = app.scrollViews.otherElements.images[phName]
        img.tap()
    }
    
    func test_room_provider_summits_room_process() {
        let testUserName = "testr@test.com"
        let testPassword = "123321A!"
        test_user_login(userName: testUserName, password: testPassword)
        checkButtonExitAndTap(acesID: "TapPaymentButton")
        let coverImage = app.scrollViews.otherElements.buttons["coverImage"]
        coverImage.tap()
        let imageSelection = app.scrollViews.otherElements.images["Photo, August 09, 2012, 5:29 AM"]
        imageSelection.tap()
        scrollText(acesID: "roomAddress", contain: "建國四路26號")
        scrollText(acesID: "town", contain: "竹山鎮")
        scrollText(acesID: "city", contain: "南投縣")
        scrollText(acesID: "zipcode", contain: "557")
        scrollText(acesID: "roomArea", contain: "12")
        scrollText(acesID: "rentalPrice", contain: "5000")
        let textEdit = app.scrollViews.otherElements.textViews["roomDes"]
        textEdit.tap()
        textEdit.typeText("Test description")
        scrollButton(acesID: "addtionalPh")
        photoSelected(phName: "Photo, August 09, 2012, 5:55 AM")
        photoSelected(phName: "Photo, August 09, 2012, 5:29 AM")
        photoSelected(phName: "Photo, August 09, 2012, 2:52 AM")
        let addButton = app.navigationBars["Photos"].buttons["Add"]
        addButton.tap()
        scrollButton(acesID: "no1")
        scrollButton(acesID: "no2")
        scrollButton(acesID: "tosAgree")
        scrollButton(acesID: "summit")
        let alertButton = app.alerts.buttons["okay"]
        alertButton.tap()
        let process = app.staticTexts["process"]
        XCTAssertFalse(process.waitForExistence(timeout: 5))
        test_user_sign_out()
    }
    
}
