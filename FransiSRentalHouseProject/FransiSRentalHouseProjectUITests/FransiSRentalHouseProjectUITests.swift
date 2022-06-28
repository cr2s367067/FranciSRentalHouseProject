//
//  FransiSRentalHouseProjectUITests.swift
//  FransiSRentalHouseProjectUITests
//
//  Created by Kuan on 2022/5/15.
//

import XCTest

class FransiSRentalHouseProjectUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }
}

class when_app_is_open_test_login_view: FransiSRentalHouseProjectUITests {
    func test_gretting_slogon() {
        let grettingTitle = app.staticTexts["Start to find your\nright place."]
        XCTAssertTrue(grettingTitle.exists)
        XCTAssertEqual(grettingTitle.label, "Start to find your\nright place.")
        let signInTitle = app.staticTexts["Sign In"]
        XCTAssertTrue(signInTitle.exists)
        XCTAssertEqual(signInTitle.label, "Sign In")
    }

    func test_login_background_image() {
        let backgroundImg = app.images["door1"]
        XCTAssert(backgroundImg.exists)
    }

    func test_forgot_password_button_exist() {
        let forgotpwdLink = app.buttons["forgotPassword"]
        XCTAssert(forgotpwdLink.exists)
        forgotpwdLink.tap()
    }

    func test_sign_up_link_exist() {
        let signUpLink = app.buttons["signUp"]
        XCTAssert(signUpLink.exists)
        signUpLink.tap()
    }

    func test_username_and_password_text_field_exit() {
        let userNameTextField = app.textFields["userName"]
        XCTAssert(userNameTextField.exists)
        let passwordTextField = app.secureTextFields["password"]
        XCTAssert(passwordTextField.exists)
    }
}

class when_app_is_open_test_sign_up_view: FransiSRentalHouseProjectUITests {
    func test_signup() {
        let signupLink = app.buttons["signUp"]
        signupLink.tap()
    }

    func test_sign_up_button_exit() {
        test_signup()
        let signUpButton = app.buttons["signUp"]
        XCTAssert(signUpButton.exists)
    }

    func test_signUp_title_exist() {
        test_signup()
        let signupTitle = app.staticTexts["Sign Up"]
        XCTAssert(signupTitle.exists)
        XCTAssertEqual(signupTitle.label, "Sign Up")
    }

    func test_sign_up_text_field() {
        test_signup()
        let usernameTextField = app.textFields["signUpUserName"]
        XCTAssert(usernameTextField.exists)
        let passwordTextField = app.secureTextFields["signUpPassword"]
        XCTAssert(passwordTextField.exists)
        let confirmPasswordTextField = app.secureTextFields["confirmPassword"]
        XCTAssert(confirmPasswordTextField.exists)
    }

    func test_user_type_and_provider_type_button() {
        test_signup()
        let provider = app.buttons["isProvider"]
        XCTAssert(provider.exists)
        let renter = app.buttons["isRenter"]
        XCTAssert(renter.exists)
        provider.tap()
        let productProvider = app.buttons["productProvider"]
        XCTAssert(productProvider.exists)
        let rentalManager = app.buttons["rentalManager"]
        XCTAssert(rentalManager.exists)
    }

    func test_license_text_field() {
        test_user_type_and_provider_type_button()
        let rentalManager = app.buttons["rentalManager"]
        rentalManager.tap()
        let licenseTextField = app.textFields["licenseNumber"]
        XCTAssert(licenseTextField.exists)
    }

    func test_term_of_service() {
        test_signup()
        let checkbox = app.buttons["tosCheckBox"]
        XCTAssert(checkbox.exists)
        let tosP1 = app.staticTexts["tosP1"]
        XCTAssert(tosP1.exists)
        let tosP2 = app.staticTexts["tosP2"]
        XCTAssert(tosP2.exists)
        tosP2.tap()
        let tosSheetTitle = app.staticTexts["tosTitle"]
        XCTAssert(tosSheetTitle.exists)
        tosSheetTitle.scrolling(direction: .scrollDown)
        let tosP3 = app.staticTexts["tosP3"]
        XCTAssert(tosP3.exists)
        let tosP4 = app.staticTexts["tosP4"]
        XCTAssert(tosP4.exists)
        tosP4.tap()
        let tosP5 = app.staticTexts["tosP5"]
        XCTAssert(tosP5.exists)
    }

    func test_sign_up_process() {
        let testUserName = "testuser2@test.com"
        let testpassword = "test123$A"
        test_signup()
        let usernameTextField = app.textFields["signUpUserName"]
        usernameTextField.tap()
        usernameTextField.typeText(testUserName)
        let passwordTextField = app.secureTextFields["signUpPassword"]
        passwordTextField.tap()
        passwordTextField.typeText(testpassword)
        let confirmPasswordTextField = app.secureTextFields["confirmPassword"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText(testpassword)
        let renter = app.buttons["isRenter"]
        renter.tap()
        let checkBox = app.buttons["tosCheckBox"]
        checkBox.tap()
        let signUpButton = app.buttons["signUp"]
        signUpButton.tap()
    }

    func test_sign_up_password_format_error() {
        let testUserName = "testuser2@test.com"
        let testpassword = "test123"
        test_signup()
        let usernameTextField = app.textFields["signUpUserName"]
        usernameTextField.tap()
        usernameTextField.typeText(testUserName)
        let passwordTextField = app.secureTextFields["signUpPassword"]
        passwordTextField.tap()
        passwordTextField.typeText(testpassword)
        let confirmPasswordTextField = app.secureTextFields["confirmPassword"]
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText(testpassword)
        let renter = app.buttons["isRenter"]
        renter.tap()
        let checkBox = app.buttons["tosCheckBox"]
        checkBox.tap()
        let signUpButton = app.buttons["signUp"]
        signUpButton.tap()
        let errorAlert = app.alerts.element
        XCTAssertTrue(errorAlert.isEnabled)
        XCTAssert(errorAlert.staticTexts["Password should be longer then 8 character"].waitForExistence(timeout: 0.5))
    }
}
