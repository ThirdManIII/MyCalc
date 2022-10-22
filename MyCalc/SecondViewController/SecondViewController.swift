//
//  SecondViewController.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 12.11.2021.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet private var thanksLabel: UILabel!
    @IBOutlet private var resultTextLabel: UILabel!
	@IBOutlet private var previousCasesStackView: UIStackView!
	@IBOutlet private var returnButton: UIButton!

    private var previousCases = [UILabel]()

	@IBAction func returnButtonAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		previousCases.forEach { label in
			label.textColor = .systemYellow
			previousCasesStackView.addArrangedSubview(label)
		}
    }

	func setPreviousCases(cases: [UILabel]) {
		previousCases = cases
	}
}
