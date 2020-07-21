//
//  Cell.swift
//  Sample
//
//  Created by Kazuya Ueoka on 2020/07/21.
//  Copyright © 2020 fromkk. All rights reserved.
//

import UIKit

final class Cell: UICollectionViewCell {
    static let reuseableIdentifier: String = String(describing: type(of: self))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private lazy var setUp: () -> Void = {
        addLabel()
        addContainerView()
        return {}
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "label"
        return label
    }()

    private func addLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16)
        ])
    }

    lazy var containerView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "containerView"
        return view
    }()

    private func addContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            containerView.heightAnchor.constraint(equalToConstant: 32),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8)
        ])
    }

    var formView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let formView = formView else { return }
            formView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(formView)
            NSLayoutConstraint.activate([
                formView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                formView.topAnchor.constraint(equalTo: containerView.topAnchor),
                containerView.trailingAnchor.constraint(equalTo: formView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: formView.bottomAnchor)
            ])
        }
    }
}
