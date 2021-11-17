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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultOutputLabel.text = result
    }
    
    @IBAction func returnButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
