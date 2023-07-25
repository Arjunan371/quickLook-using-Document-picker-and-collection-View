//
//  quickLook_using_Document_picker_and_collection_ViewUITestsLaunchTests.swift
//  quickLook using Document picker and collection ViewUITests
//
//  Created by Mohammed Abdullah on 19/07/23.
//

import XCTest

final class quickLook_using_Document_picker_and_collection_ViewUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
