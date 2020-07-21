//
//  ViewController.swift
//  Sample
//
//  Created by Kazuya Ueoka on 2020/07/21.
//  Copyright © 2020 fromkk. All rights reserved.
//

import UIKit
import MovableToolbar

class ViewController: UIViewController, MovableToolbarDataSource, MovableToolbarDelegate {

    deinit {
        unregisterNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        configureDataSource()
        registerNotifications()
    }

    // MARK: - Toolbar

    lazy var toolbar: MovableToolbar = {
        let toolbar = MovableToolbar(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.size.width, height: 44)))
        toolbar.accessibilityIdentifier = "toolbar"
        toolbar.toolbarDataSource = self
        toolbar.toolbarDelegate = self
        return toolbar
    }()

    // MARK: MovableToolbarDataSource

    func numberOfRows(in toolbar: MovableToolbar) -> Int {
        return Item.allCases.count
    }

    func inputView(with toolbar: MovableToolbar, row: Int) -> UIView? {
        return textField(of: Item.allCases[row])
    }

    // MARK: MovableToolbarDelegate

    func currentInputView(with toolbar: MovableToolbar) -> UIView? {
        return Item.allCases.map { textField(of: $0) }.first { textField -> Bool in
            return textField.isFirstResponder
        }
    }

    // MARK: - CollectionView

    lazy var collectionViewLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseableIdentifier)
        collectionView.accessibilityIdentifier = "collectionView"
        return collectionView
    }()

    private func addCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }

    lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseableIdentifier, for: indexPath) as! Cell
        cell.label.text = item.localized()
        cell.formView = self.textField(of: item)
        return cell
    }

    private func configureDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.form])
        snapshot.appendItems(Item.allCases)
        dataSource.apply(snapshot)
    }

    // MARK: Data Sources

    enum Section {
        case form
    }

    enum Item: String, Localizable, CaseIterable {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case address
    }

    private func textField(of item: Item) -> UITextField {
        switch item {
        case .firstName:
            return firstNameTextField
        case .lastName:
            return lastNameTextField
        case .email:
            return emailTextField
        case .password:
            return passwordTextField
        case .address:
            return addressTextField
        }
    }

    lazy var firstNameTextField: UITextField = makeTextField(keyboardType: .default, isSecureTextEntry: false)
    lazy var lastNameTextField: UITextField = makeTextField(keyboardType: .default, isSecureTextEntry: false)
    lazy var emailTextField: UITextField = makeTextField(keyboardType: .emailAddress, isSecureTextEntry: false)
    lazy var passwordTextField: UITextField = makeTextField(keyboardType: .asciiCapable, isSecureTextEntry: true)
    lazy var addressTextField: UITextField = makeTextField(keyboardType: .default, isSecureTextEntry: false)

    private func makeTextField(keyboardType: UIKeyboardType, isSecureTextEntry: Bool) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.inputAccessoryView = toolbar
        return textField
    }

    // MARK: - Notifications

    private var keyboardWillShowObservation: NSObjectProtocol?
    private var keyboardWillHideObservation: NSObjectProtocol?

    private func registerNotifications() {
        keyboardWillShowObservation = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] notification in
            guard let keyboard = notification.keyboard else { return }
            UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationCurve, animations: { [weak self] in
                self?.collectionView.contentInset.bottom = keyboard.frame.size.height
            }, completion: nil)
        })
        keyboardWillHideObservation = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { notification in
            guard let keyboard = notification.keyboard else { return }
            UIView.animate(withDuration: keyboard.animationDuration, delay: 0, options: keyboard.animationCurve, animations: { [weak self] in
                self?.collectionView.contentInset.bottom = 0
            }, completion: nil)
        })
    }

    private func unregisterNotifications() {
        [keyboardWillShowObservation, keyboardWillHideObservation].compactMap { $0 }.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
}
