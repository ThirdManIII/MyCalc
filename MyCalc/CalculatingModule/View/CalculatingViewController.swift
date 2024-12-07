//
//  ViewController.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 23.10.2021.
//

import UIKit

final class CalculatingViewController: UIViewController {
	@IBOutlet private var holder: UIView!
	@IBOutlet private var askAnswerContainerView: UIView!
	@IBOutlet private var resultsStackView: UIStackView!
	@IBOutlet private var askAnswerLabel: UILabel!
	@IBOutlet private var gradientView: UIView!

	@IBOutlet private var destroyItAllButton: UIButton!
	@IBOutlet private var button1: UIButton!
	@IBOutlet private var button2: UIButton!
	@IBOutlet private var button3: UIButton!
	@IBOutlet private var button4: UIButton!
	@IBOutlet private var button5: UIButton!
	@IBOutlet private var button6: UIButton!
	@IBOutlet private var button7: UIButton!
	@IBOutlet private var button8: UIButton!
	@IBOutlet private var button9: UIButton!
	@IBOutlet private var punktButton: UIButton!
	@IBOutlet private var button0: UIButton!
	@IBOutlet private var deleteButton: UIButton!
	@IBOutlet private var equalButton: UIButton!
	@IBOutlet private var plusButton: UIButton!
	@IBOutlet private var minusButton: UIButton!
	@IBOutlet private var multiplButton: UIButton!
	@IBOutlet private var divideButton: UIButton!
	@IBOutlet private var openSecondViewButton: UIButton!
	@IBOutlet private var leftBracketButton: UIButton!
	@IBOutlet var rightBracketButton: UIButton!
	
	private enum Constants {
		static let cornerRadius: CGFloat = 20.0
		static let prevResultFontSize: CGFloat = 25.0
		static let secondVCId: String = "SecondViewControllerID"
		static let fontName: String = "Futura Medium"
		static let startGradientColor: CGColor = UIColor.white.cgColor
		static let endGradientColor: CGColor = UIColor.white.withAlphaComponent(0.0).cgColor
	}

	private lazy var output: CalculatingViewOutput = CalculatingPresenter(view: self)

	private let titleView = MyCalcTitleView()
	private let gradient = CAGradientLayer()

	private var labelOutput = ""
	private var previousCasesLabels = [UILabel]()
	private var showedCasesLabels = [UILabel]()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		output.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		showedCasesLabels.forEach { label in
			label.textColor = .black
			resultsStackView.addArrangedSubview(label)
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.async {
			self.gradient.frame = self.gradientView.bounds
		}
	}

	@IBAction func buttonOneAction(_ sender: UIButton) {
		output.numberPressed(.one)
	}

	@IBAction func buttonTwoAction(_ sender: UIButton) {
		output.numberPressed(.two)
	}

	@IBAction func buttonThreeAction(_ sender: UIButton) {
		output.numberPressed(.three)
	}

	@IBAction func buttonFourAction(_ sender: UIButton) {
		output.numberPressed(.four)
	}

	@IBAction func buttonFiveAction(_ sender: Any) {
		output.numberPressed(.five)
	}

	@IBAction func buttonSixAction(_ sender: Any) {
		output.numberPressed(.six)
	}

	@IBAction func buttonSevenAction(_ sender: Any) {
		output.numberPressed(.seven)
	}

	@IBAction func buttonEightAction(_ sender: Any) {
		output.numberPressed(.eight)
	}

	@IBAction func buttonNineAction(_ sender: Any) {
		output.numberPressed(.nine)
	}

	@IBAction func buttonZeroAction(_ sender: Any) {
		output.numberPressed(.zero)
	}

	@IBAction func plusButtonAction(_ sender: UIButton) {
		output.plusPressed()
	}

	@IBAction func minusButtonAction(_ sender: Any) {
		output.minusPressed()
	}

	@IBAction func multiplButtonAction(_ sender: Any) {
		output.multiplyPressed()
	}

	@IBAction func divideButtonAction(_ sender: Any) {
		output.dividePressed()
	}

	@IBAction func equalButtonAction(_ sender: UIButton) {
		output.equalPressed()
	}

	@IBAction func deleteButtonAction(_ sender: UIButton) {
		output.deletePressed()
	}

	@IBAction func destroyItAllButtonAction(_ sender: UIButton) {
		output.destroyPressed()
	}

	@IBAction func punktButtonAction(_ sender: UIButton) {
		output.punktPressed()
	}

	@IBAction func openSVCButtonAction(_ sender: UIButton) {
		guard let newView = self.storyboard?.instantiateViewController(
			withIdentifier: Constants.secondVCId
		) as? SecondViewController else {
			return
		}
		newView.setPreviousCases(cases: previousCasesLabels)
		self.navigationController?.pushViewController(newView, animated: true)
	}
	@IBAction func leftBracketButtonAction(_ sender: UIButton) {
	}
	@IBAction func rightBracketButtonAction(_ sender: UIButton) {
	}
}

// MARK: - View Input

extension CalculatingViewController: CalculatingViewInput {
	func setTitle(_ title: String) {
		titleView.set(title: title)
	}

	func setAskAnswer(with text: String?) {
		askAnswerLabel.text = text
	}

	func rememberAndShowPreviousCase(_ prevCase: String) {
		let label = UILabel()
		label.textColor = .black
		label.font = UIFont(name: Constants.fontName,
							size: Constants.prevResultFontSize)
		label.text = prevCase

		resultsStackView.addArrangedSubview(label)
		previousCasesLabels.append(label)
		showedCasesLabels.append(label)
	}

	func cleanCases() {
		showedCasesLabels = []
		while !resultsStackView.arrangedSubviews.isEmpty {
			resultsStackView.arrangedSubviews[0].removeFromSuperview()
		}
	}
}

// MARK: - Private

extension CalculatingViewController {
	// MARK: User Interface

	private func setupSubviews() {
		setNeedsStatusBarAppearanceUpdate()
		askAnswerContainerView.layer.cornerRadius = Constants.cornerRadius
		askAnswerContainerView.clipsToBounds = true
		navigationItem.titleView = titleView

		setupGradient()
	}

	private func setupGradient() {
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
		gradient.colors = [Constants.startGradientColor, Constants.endGradientColor]
		gradientView.layer.addSublayer(gradient)
	}
}
