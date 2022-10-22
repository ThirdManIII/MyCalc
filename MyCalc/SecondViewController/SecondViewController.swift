//
//  SecondViewController.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 12.11.2021.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet var thanksLabel: UILabel!
    @IBOutlet var resultTextLabel: UILabel!
    @IBOutlet var resultOutputLabel: UILabel!
    @IBOutlet var returnButton: UIButton!

    var result = ""

	@IBAction func returnButtonAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        resultOutputLabel.text = result
		returnButton.tintColor = .systemOrange
    }
}
