//
//  MovableToolbarTests.swift
//  MovableToolbarTests
//
//  Created by Kazuya Ueoka on 2020/07/21.
//  Copyright © 2020 fromkk. All rights reserved.
//

import XCTest
@testable import MovableToolbar

class MovableToolbarTests: XCTestCase {
    var dataSourceAndDelegate: MovableToolbarDataSourceStub!
    var toolbar: MovableToolbar!

    private func reset() {
        dataSourceAndDelegate = .init()
        toolbar = MovableToolbar()
        toolbar.toolbarDataSource = dataSourceAndDelegate
        toolbar.toolbarDelegate = dataSourceAndDelegate
    }

    override func setUp() {
        super.setUp()
        reset()
    }

    func testCanGoBack() {
        XCTContext.runActivity(named: "can't go back(selectedIndex is nil)") { _ in
            reset()
            toolbar.selectedIndex = nil
            XCTAssertFalse(toolbar.canGoBack)
        }

        XCTContext.runActivity(named: "can't go back(selectedIndex is zero)") { _ in
            reset()
            toolbar.selectedIndex = 0
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            XCTAssertFalse(toolbar.canGoBack)
        }

        XCTContext.runActivity(named: "can go back") { _ in
            reset()
            toolbar.selectedIndex = 1
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            XCTAssertTrue(toolbar.canGoBack)
        }
    }

    func testCanGoForward() {
        XCTContext.runActivity(named: "can't go forward(selectedIndex is nil)") { _ in
            reset()
            toolbar.selectedIndex = nil
            XCTAssertFalse(toolbar.canGoForward)
        }

        XCTContext.runActivity(named: "can't go forward(selectedIndex is zero)") { _ in
            reset()
            toolbar.selectedIndex = 3
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            XCTAssertFalse(toolbar.canGoForward)
        }

        XCTContext.runActivity(named: "can go back") { _ in
            reset()
            toolbar.selectedIndex = 1
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            XCTAssertTrue(toolbar.canGoForward)
        }
    }

    private func goBack() {
        toolbar.tap(backButton: toolbar.backButton)
    }

    private func goForward() {
        toolbar.tap(forwardButton: toolbar.forwardButton)
    }

    func testGoBack() {
        XCTContext.runActivity(named: "can't go back") { _ in
            reset()
            toolbar.selectedIndex = nil
            goBack()
            XCTAssertNil(toolbar.selectedIndex)
        }

        XCTContext.runActivity(named: "can go back") { _ in
            reset()
            toolbar.selectedIndex = 1
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            goBack()
            XCTAssertEqual(toolbar.selectedIndex, 0)
        }
    }

    func testGoForward() {
        XCTContext.runActivity(named: "can't go forward") { _ in
            reset()
            toolbar.selectedIndex = nil
            goForward()
            XCTAssertNil(toolbar.selectedIndex)
        }

        XCTContext.runActivity(named: "can go forward") { _ in
            reset()
            toolbar.selectedIndex = 1
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            goForward()
            XCTAssertEqual(toolbar.selectedIndex, 2)
        }
    }

    func testDidBeginEditing() {
        XCTContext.runActivity(named: "textField") { _ in
            reset()
            XCTAssertNil(toolbar.selectedIndex)
            let textField = UITextField()
            dataSourceAndDelegate.stubbedCurrentInputViewResult = textField
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            dataSourceAndDelegate.stubbedInputViewResult = textField
            NotificationCenter.default.post(name: UITextField.textDidBeginEditingNotification, object: textField)
            XCTAssertEqual(toolbar.selectedIndex, 0)
        }

        XCTContext.runActivity(named: "textView") { _ in
            reset()
            XCTAssertNil(toolbar.selectedIndex)
            let textView = UITextView()
            dataSourceAndDelegate.stubbedCurrentInputViewResult = textView
            dataSourceAndDelegate.stubbedNumberOfRowsResult = 3
            dataSourceAndDelegate.stubbedInputViewResult = textView
            NotificationCenter.default.post(name: UITextView.textDidBeginEditingNotification, object: textView)
            XCTAssertEqual(toolbar.selectedIndex, 0)
        }
    }
}
