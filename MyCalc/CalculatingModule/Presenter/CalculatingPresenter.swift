//
//  Presenter.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 21.08.2024.
//

import Foundation

final class CalculatingPresenter {
	private enum Constants {
		static let zeroDivideText: String = "Деление на ноль"
		static let navBarTitle: String = "MyCalc"
	}

	private let view: CalculatingViewInput

	private var numbers: [String] = []
	private var operators: [CalculatingOperators] = []
	private var resultInFloat: Float = 0
	private var isOperationInput = false

	init(view: CalculatingViewInput) {
		self.view = view
	}
}

// MARK: - View Output

extension CalculatingPresenter: CalculatingViewOutput {
	func viewDidLoad() {
		view.setTitle(Constants.navBarTitle)
	}

	func plusPressed() {
		addOperator(.plus)
	}

	func minusPressed() {
		if !numbers.isEmpty {
			addOperator(.minus)
		} else {
			numbers.append("-")
			printCase()
		}
	}

	func multiplyPressed() {
		addOperator(.multiplicate)
	}

	func dividePressed() {
		addOperator(.divide)
	}

	func deletePressed() {
		guard !numbers.isEmpty else {
			return
		}
		performDeletion()
	}

	func destroyPressed() {
		destroyItAll()
	}

	func equalPressed() {
		guard numbers.count >= 2, operators.count >= 1 else {
			return
		}

		// Формирование строки примера
		var caseToShow = ""
		numbers.enumerated().forEach { index, number in
			caseToShow += number
			if operators.count >= index + 1 {
				caseToShow += operators[index].rawValue
			}
		}

		// Вычисление
		while numbers.count > 1 {
			let operations = operators.enumerated().map { index, anOperator in
				let firstNumber = numbers[index]
				let secondNumber = numbers[index + 1]

				return CalculatingCaseModel(
					caseOperator: anOperator,
					firstNumber: Float(firstNumber) ?? 0.0,
					secondNumber: Float(secondNumber) ?? 0.0
				)
			}

			var foregroundOperation = operations.first(where: {
				$0.caseOperator == .multiplicate || $0.caseOperator == .divide
			})
			var foregroundOperationIndex = operations.firstIndex { model in
				model.caseOperator == .multiplicate || model.caseOperator == .divide
			}

			var operationIndex: Int = foregroundOperationIndex ?? 0
			var resultNumber: Float = 0

			if let foregroundOperation {
				if foregroundOperation.caseOperator == .multiplicate {
					resultNumber = foregroundOperation.firstNumber * foregroundOperation.secondNumber
				} else {
					resultNumber = foregroundOperation.firstNumber / foregroundOperation.secondNumber
				}
			} else {
				guard let operation = operations.first else {
					return
				}

				if operation.caseOperator == .plus {
					resultNumber = operation.firstNumber + operation.secondNumber
				} else {
					resultNumber = operation.firstNumber - operation.secondNumber
				}
			}

			// Удаление знака разрешённой операции
			operators.remove(at: operationIndex)

			// Удаление числа справа от удаляемого знака
			numbers.remove(at: operationIndex + 1)

			// Замена числа в нужном месте на результат выполненной операции
			numbers[operationIndex] = transformedFloatToString(resultNumber)

			foregroundOperation = nil
			foregroundOperationIndex = nil
			operationIndex = 0
		}

		view.setAskAnswer(with: numbers.first)

		view.rememberAndShowPreviousCase(caseToShow)

		isOperationInput = false
	}

	func punktPressed() {
		if numbers.count > operators.count {
			numbers[numbers.endIndex - 1] = addPoint(number: numbers[numbers.endIndex - 1])
			printCase()
		} else {
			numbers.append(addPoint(number: ""))
			printCase()
		}
	}

	func numberPressed(_ numberType: CalculatingNumbers) {
		addNumber(number: "\(numberType.rawValue)")
	}
}

// MARK: - Private

extension CalculatingPresenter {
	// MARK: Operations

	private func addOperator(_ currentOperator: CalculatingOperators) {
		guard !numbers.isEmpty else {
			return
		}
		if isOperationInput {
			operators.removeLast()
		}
		isOperationInput = true
		operators.append(currentOperator)
		printCase()
	}

	private func performOperation(numberOne: String, numberTwo: String, currentOperator: CalculatingOperators) {
		guard let numberOne = Float(numberOne), let numberTwo = Float(numberTwo) else {
			return
		}
		switch currentOperator {
		case .plus:
			resultInFloat = numberOne + numberTwo
		case .minus:
			resultInFloat = numberOne - numberTwo
		case .multiplicate:
			resultInFloat = numberOne * numberTwo
		case .divide:
			guard numberTwo != 0 else {
				destroyItAll()
				view.setAskAnswer(with: Constants.zeroDivideText)
				return
			}
			resultInFloat = numberOne / numberTwo
		}
	}

	private func addNumber(number: String) {
		if numbers.count == operators.count {
			numbers.append(number)
		} else {
			if numbers[numbers.endIndex - 1] == "0" {
				numbers[numbers.endIndex - 1] = ""
			}
			numbers[numbers.endIndex - 1] += number
		}
		printCase()
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

	private func printCase() {
		var caseToShow = ""
		for index in 0 ..< numbers.count {
			caseToShow += numbers[index]
			if operators.count >= index + 1 {
				caseToShow += operators[index].rawValue
			}
		}
		view.setAskAnswer(with: caseToShow)
	}

	private func performDeletion() {
		if numbers.count == operators.count {
			operators.removeLast()
			printCase()
		} else {
			numbers[numbers.endIndex - 1] = deleteSymbol(operationString: numbers.last ?? "")
			view.setAskAnswer(with: numbers.last)
		}
	}

	private func deleteSymbol(operationString: String) -> String {
		guard !operationString.isEmpty, operationString != "0" else {
			return "0"
		}
		var resultString = operationString
		resultString.remove(at: operationString.index(before: operationString.endIndex))
		return resultString.isEmpty ? "0" : resultString
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
		numbers = []
		operators = []
		resultInFloat = 0
		isOperationInput = false
		view.setAskAnswer(with: "0")
		view.cleanCases()
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
