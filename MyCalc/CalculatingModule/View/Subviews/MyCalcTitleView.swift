//
//  MyCalcTitleView.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 22.10.2022.
//

import UIKit

final class MyCalcTitleView: UIView {
	private let titleView = UIView()
	private let titleLabel = UILabel()

	private enum Constants {
		static let fontName: String = "Futura Medium"
		static let fontSize: CGFloat = 30.0
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupSubviews()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}

	func set(title: String) {
		titleLabel.text = title
	}
}

// MARK: - Private

extension MyCalcTitleView {
	private func setupSubviews() {
		setupTitleLabel()
		addSubview(titleView)
		titleView.addSubview(titleLabel)
		titleView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
		])
	}

	private func setupTitleLabel() {
		titleLabel.font = UIFont(name: Constants.fontName, size: Constants.fontSize)
		titleLabel.textColor = .systemOrange
	}
}
