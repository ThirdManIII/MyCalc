//
//  ViewController.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 23.10.2021.
//

import UIKit

enum Operation: String {
	case plus = "+"
	case minus = "-"
	case multiplicate = "×"
	case divide = "÷"
}

final class ViewController: UIViewController {
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

	private enum Constants {
		static let cornerRadius: CGFloat = 20.0
		static let prevResultFontSize: CGFloat = 25.0
		static let secondVCId: String = "SecondViewControllerID"
		static let zeroDivideText: String = "Деление на ноль"
		static let navBarTitle: String = "MyCalc"
		static let fontName: String = "Futura Medium"
		static let startGradientColor: CGColor = UIColor.white.cgColor
		static let endGradientColor: CGColor = UIColor.white.withAlphaComponent(0.0).cgColor
	}

	private let titleView = MyCalcTitleView()
	private let gradient = CAGradientLayer()

	private var number1inString = ""
	private var number2inString = ""
	private var labelOutput = ""
	private var resultInFloat: Float = 0
	private var previousCasesLabels = [UILabel]()
	private var showedCasesLabels = [UILabel]()
	private var operationIndikator = false
	private var currentOperation: Operation?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
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
		addNumber(number: "1")
	}

	@IBAction func buttonTwoAction(_ sender: UIButton) {
		addNumber(number: "2")
	}

	@IBAction func buttonThreeAction(_ sender: UIButton) {
		addNumber(number: "3")
	}

	@IBAction func buttonFourAction(_ sender: UIButton) {
		addNumber(number: "4")
	}

	@IBAction func buttonFiveAction(_ sender: Any) {
		addNumber(number: "5")
	}

	@IBAction func buttonSixAction(_ sender: Any) {
		addNumber(number: "6")
	}

	@IBAction func buttonSevenAction(_ sender: Any) {
		addNumber(number: "7")
	}

	@IBAction func buttonEightAction(_ sender: Any) {
		addNumber(number: "8")
	}

	@IBAction func buttonNineAction(_ sender: Any) {
		addNumber(number: "9")
	}

	@IBAction func buttonZeroAction(_ sender: Any) {
		addNumber(number: "0")
	}

	@IBAction func plusButtonAction(_ sender: UIButton) {
		guard !number1inString.isEmpty else {
			return
		}
		operationIndikator = true
		currentOperation = .plus
		printNumberTwo()
	}

	@IBAction func minusButtonAction(_ sender: Any) {
		if !number1inString.isEmpty {
			operationIndikator = true
			currentOperation = .minus
			printNumberTwo()
		} else {
			number1inString = "-"
			printNumberOne()
		}
	}

	@IBAction func multiplButtonAction(_ sender: Any) {
		guard !number1inString.isEmpty else {
			return
		}
		operationIndikator = true
		currentOperation = .multiplicate
		printNumberTwo()
	}

	@IBAction func divideButtonAction(_ sender: Any) {
		guard !number1inString.isEmpty else {
			return
		}
		operationIndikator = true
		currentOperation = .divide
		printNumberTwo()
	}

	@IBAction func equalButtonAction(_ sender: UIButton) {
		guard !number2inString.isEmpty else {
			return
		}
		guard currentOperation != .divide || number2inString != "0" else {
			destroyItAll()
			askAnswerLabel.text = Constants.zeroDivideText
			return
		}

		switch currentOperation {
		case .plus:
			operationPlus()
		case .minus:
			operationMinus()
		case .multiplicate:
			operationMultipl()
		case .divide:
			operationDivide()
		default:
			return
		}

		let resultInString = transformedFloatToString(resultInFloat)
		askAnswerLabel.text = resultInString
		if let currentOperation = currentOperation {
			let prevCase = number1inString + currentOperation.rawValue + number2inString + "=" + resultInString
			rememberAndShowPreviousCase(prevCase)
		}

		number1inString = transformedFloatToString(resultInFloat)
		number2inString = ""
		operationIndikator = false
	}

	@IBAction func deleteButtonAction(_ sender: UIButton) {
		guard !number1inString.isEmpty else {
			return
		}
		if !operationIndikator {
			number1inString = deleteSymbol(operationString: number1inString)
			if !number1inString.isEmpty {
				printNumberOne()
			} else {
				askAnswerLabel.text = "0"
			}
		} else {
			guard !number2inString.isEmpty else {
				operationIndikator = false
				printNumberOne()
				return
			}
			number2inString = deleteSymbol(operationString: number2inString)
			printNumberTwo()
		}
	}

	@IBAction func destroyItAllButtonAction(_ sender: UIButton) {
		destroyItAll()
	}

	@IBAction func punktButtonAction(_ sender: UIButton) {
		if operationIndikator != true {
			number1inString = addPoint(number: number1inString)
			printNumberOne()
		} else {
			number2inString = addPoint(number: number2inString)
			printNumberTwo()
		}
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
}

// MARK: - Private

extension ViewController {
	// MARK: User Interface

	private func setupSubviews() {
		setNeedsStatusBarAppearanceUpdate()
		askAnswerContainerView.layer.cornerRadius = Constants.cornerRadius
		askAnswerContainerView.clipsToBounds = true
		titleView.set(title: Constants.navBarTitle)
		navigationItem.titleView = titleView

		setupGradient()
	}

	private func setupGradient() {
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
		gradient.colors = [Constants.startGradientColor, Constants.endGradientColor]
		gradientView.layer.addSublayer(gradient)
	}

	// MARK: Operations

	private func operationPlus() {
		guard let numberOne = Float(number1inString), let numberTwo = Float(number2inString) else {
			return
		}
        resultInFloat = numberOne + numberTwo
    }

	private func operationMinus() {
		guard let numberOne = Float(number1inString), let numberTwo = Float(number2inString) else {
			return
		}
        resultInFloat = numberOne - numberTwo
    }

	private func operationMultipl() {
		guard let numberOne = Float(number1inString), let numberTwo = Float(number2inString) else {
			return
		}
        resultInFloat = numberOne * numberTwo
    }

	private func operationDivide() {
		guard let numberOne = Float(number1inString), let numberTwo = Float(number2inString) else {
			return
		}
        resultInFloat = numberOne / numberTwo
    }

	private func addNumber(number: String) {
        if operationIndikator != true {
            number1inString += number
            number1inString = deleteFirstZero(number: number1inString)
            printNumberOne()
        } else {
            number2inString += number
            number2inString = deleteFirstZero(number: number2inString)
            printNumberTwo()
        }
    }

	private func printCurrentOperation() {
        guard let currentOperation = currentOperation else {
            return
        }
        askAnswerLabel.text = number1inString + currentOperation.rawValue
    }

	private func addPoint(number: String) -> String {
        guard !number.contains(".") else {
            return number
        }
        if !number.isEmpty {
            return number + "."
        } else {
            return "0."
        }
    }

	private func deleteSymbol(operationString: String) -> String {
        var resultString = operationString
        resultString.remove(at: operationString.index(before: operationString.endIndex))
        return resultString
    }

	private func printNumberOne() {
        askAnswerLabel.text = number1inString
    }

	private func printNumberTwo() {
        guard let currentOperation = currentOperation else {
            return
        }
        askAnswerLabel.text = number1inString + currentOperation.rawValue + number2inString
    }

	private func deleteFirstZero(number: String) -> String {
        let firstNumber = number[number.startIndex]
        guard firstNumber == "0", !number.contains("."), number.count > 1 else {
            return number
        }
        var numberNew = number
        numberNew.remove(at: numberNew.startIndex)
        return numberNew
    }

	private func destroyItAll() {
        number1inString = ""
        number2inString = ""
        resultInFloat = 0
        operationIndikator = false
        currentOperation = nil
        askAnswerLabel.text = "0"
		showedCasesLabels = []
		while !resultsStackView.arrangedSubviews.isEmpty {
			resultsStackView.arrangedSubviews[0].removeFromSuperview()
		}
    }

	private func rememberAndShowPreviousCase(_ prevCase: String) {
		let label = UILabel()
		label.textColor = .black
		label.font = UIFont(name: Constants.fontName,
							size: Constants.prevResultFontSize)
		label.text = prevCase

		resultsStackView.addArrangedSubview(label)
		previousCasesLabels.append(label)
		showedCasesLabels.append(label)
	}

	private func transformedFloatToString(_ value: Float) -> String {
		let stringValue = String(value)
		if stringValue.hasSuffix(".0") {
			return String(Int(value))
		} else {
			return stringValue
		}
	}
}
