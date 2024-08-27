//
//  CalculatingContracts.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 21.08.2024.
//

import Foundation

// View Output
protocol CalculatingViewOutput {
	func viewDidLoad()
	func plusPressed()
	func minusPressed()
	func multiplyPressed()
	func dividePressed()
	func punktPressed()
	func deletePressed()
	func destroyPressed()
	func equalPressed()
	func numberPressed(_ numberType: CalculatingNumbers)
}

// View Input
protocol CalculatingViewInput {
	func setTitle(_ title: String)
	func setAskAnswer(with text: String?)
	func rememberAndShowPreviousCase(_ prevCase: String)
	func cleanCases()
}
