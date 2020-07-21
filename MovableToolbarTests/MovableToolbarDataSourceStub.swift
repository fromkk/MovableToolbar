//
//  MovableToolbarDataSourceStub.swift
//  MovableToolbarTests
//
//  Created by Kazuya Ueoka on 2020/07/21.
//  Copyright © 2020 fromkk. All rights reserved.
//

import UIKit
@testable import MovableToolbar

final class MovableToolbarDataSourceStub: MovableToolbarDataSource, MovableToolbarDelegate {

    var invokedNumberOfRows = false
    var invokedNumberOfRowsCount = 0
    var invokedNumberOfRowsParameters: (toolbar: MovableToolbar, Void)?
    var invokedNumberOfRowsParametersList = [(toolbar: MovableToolbar, Void)]()
    var stubbedNumberOfRowsResult: Int! = 0

    func numberOfRows(in toolbar: MovableToolbar) -> Int {
        invokedNumberOfRows = true
        invokedNumberOfRowsCount += 1
        invokedNumberOfRowsParameters = (toolbar, ())
        invokedNumberOfRowsParametersList.append((toolbar, ()))
        return stubbedNumberOfRowsResult
    }

    var invokedInputView = false
    var invokedInputViewCount = 0
    var invokedInputViewParameters: (toolbar: MovableToolbar, row: Int)?
    var invokedInputViewParametersList = [(toolbar: MovableToolbar, row: Int)]()
    var stubbedInputViewResult: UIView!

    func inputView(with toolbar: MovableToolbar, row: Int) -> UIView? {
        invokedInputView = true
        invokedInputViewCount += 1
        invokedInputViewParameters = (toolbar, row)
        invokedInputViewParametersList.append((toolbar, row))
        return stubbedInputViewResult
    }

    var invokedCurrentInputView = false
    var invokedCurrentInputViewCount = 0
    var invokedCurrentInputViewParameters: (toolbar: MovableToolbar, Void)?
    var invokedCurrentInputViewParametersList = [(toolbar: MovableToolbar, Void)]()
    var stubbedCurrentInputViewResult: UIView!

    func currentInputView(with toolbar: MovableToolbar) -> UIView? {
        invokedCurrentInputView = true
        invokedCurrentInputViewCount += 1
        invokedCurrentInputViewParameters = (toolbar, ())
        invokedCurrentInputViewParametersList.append((toolbar, ()))
        return stubbedCurrentInputViewResult
    }
}
