//
//  MovableToolbar.swift
//  MovableToolbar
//
//  Created by Kazuya Ueoka on 2020/07/21.
//  Copyright © 2020 fromkk. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public protocol MovableToolbarDataSource: AnyObject {
    func numberOfRows(in toolbar: MovableToolbar) -> Int
    func inputView(with toolbar: MovableToolbar, row: Int) -> UIView?
}

@available(iOS 13.0, *)
public protocol MovableToolbarDelegate: AnyObject {
    func currentInputView(with toolbar: MovableToolbar) -> UIView?
}

@available(iOS 13.0, *)
@IBDesignable
open class MovableToolbar: UIToolbar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }

    private lazy var setUp: () -> Void = {
        let flexibleSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpacer.width = 16.0

        items = [backButton, fixedSpacer, forwardButton, flexibleSpacer, closeButton]

        NotificationCenter.default.addObserver(self, selector: #selector(inputViewDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputViewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        return {}
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func inputViewDidBeginEditing(_: Notification) {
        guard let currentInputView: UIView = toolbarDelegate?.currentInputView(with: self) else {
            selectedIndex = nil
            return
        }

        let numberOfRows: Int = toolbarDataSource?.numberOfRows(in: self) ?? 0
        for i in 0 ..< numberOfRows {
            guard let inputView: UIView = toolbarDataSource?.inputView(with: self, row: i) else { continue }
            guard inputView.isEqual(currentInputView) else { continue }
            selectedIndex = i
            break
        }
    }

    public weak var toolbarDataSource: MovableToolbarDataSource?
    public weak var toolbarDelegate: MovableToolbarDelegate?

    private var range: CountableRange<Int> { 0 ..< (toolbarDataSource?.numberOfRows(in: self) ?? 0) }

    internal(set) public var selectedIndex: Int? {
        didSet {
            backButton.isEnabled = canGoBack
            forwardButton.isEnabled = canGoForward
            guard let inputView: UIView = selectedInputView, inputView.canBecomeFirstResponder else { return }
            inputView.becomeFirstResponder()
        }
    }

    public var selectedInputView: UIView? {
        guard let selectedIndex = selectedIndex else { return nil }
        return toolbarDataSource?.inputView(with: self, row: selectedIndex)
    }

    public lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(self.tap(backButton:)))
    public lazy var forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(tap(forwardButton:)))
    public lazy var closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(self.tap(closeButton:)))

    public var canGoBack: Bool {
        guard let selectedIndex = selectedIndex else {
            return false
        }
        let backIndex: Int = selectedIndex - 1
        return range.contains(backIndex)
    }

    public var canGoForward: Bool {
        guard let selectedIndex = selectedIndex else {
            return false
        }
        let forwardIndex: Int = selectedIndex + 1
        return range.contains(forwardIndex)
    }

    @objc internal func tap(backButton _: UIBarButtonItem) {
        guard let selectedIndex = selectedIndex else {
            return
        }
        guard canGoBack else { return }
        self.selectedIndex = selectedIndex - 1
    }

    @objc internal func tap(forwardButton _: UIBarButtonItem) {
        guard let selectedIndex = selectedIndex else {
            return
        }
        guard canGoForward else { return }
        self.selectedIndex = selectedIndex + 1
    }

    @objc internal func tap(closeButton _: UIBarButtonItem) {
        toolbarDelegate?.currentInputView(with: self)?.resignFirstResponder()
    }
}
