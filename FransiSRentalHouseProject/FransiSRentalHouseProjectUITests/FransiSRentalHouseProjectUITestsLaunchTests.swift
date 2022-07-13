//
//  FransiSRentalHouseProjectUITestsLaunchTests.swift
//  FransiSRentalHouseProjectUITests
//
//  Created by Kuan on 2022/5/15.
//

import SpriteKit
import SwiftUI
import XCTest

class FransiSRentalHouseProjectUITestsLaunchTests: XCTestCase {
    var app: XCUIApplication!

//    override class var runsForEachTargetApplicationUIConfiguration: Bool {
//        true
//    }

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
}

extension XCUIElement {
    enum ScrollDirection {
        case scrollUp
        case scrollDown
    }

    func scrolling(direction: ScrollDirection) {
        let half: CGFloat = 0
        let adjust: CGFloat = 50

        let toTop = half - adjust
        let toButton = half + adjust

        let center = coordinate(withNormalizedOffset: CGVector(dx: half, dy: half))
        let scrollToTop = coordinate(withNormalizedOffset: CGVector(dx: half, dy: toTop))
        let scrollToButton = coordinate(withNormalizedOffset: CGVector(dx: half, dy: toButton))

        switch direction {
        case .scrollUp:
            return center.press(forDuration: 0, thenDragTo: scrollToTop)
        case .scrollDown:
            return center.press(forDuration: 0, thenDragTo: scrollToButton)
        }
    }
}
