//
//  ViewController.swift
//  MyCalc
//
//  Created by Vladislav Kuchurin on 23.10.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var holder: UIView!
    @IBOutlet var askAnswerLabel: UILabel!
    @IBOutlet var destroyItAllButton: UIButton!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var punktButton: UIButton!
    @IBOutlet var button0: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var equalButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var multiplButton: UIButton!
    @IBOutlet var divideButton: UIButton!
    @IBOutlet var openSecondViewButton: UIButton!
    
    var number1inString = ""
    var number2inString = ""
    var labelOutput = ""
    var resultInDouble: Double = 0
    var operationIndikator = false
    var currentOperation: Operation?
    enum Operation: String {
        case plus = "+"
        case minus = "-"
        case multiplicate = "•"
        case divide = "÷"
    }
    
    func operationPlus() {
        resultInDouble = Double(number1inString)! + Double(number2inString)!
    }
    
    func operationMinus() {
        resultInDouble = Double(number1inString)! - Double(number2inString)!
    }
    
    func operationMultipl() {
        resultInDouble = Double(number1inString)! * Double(number2inString)!
    }
    
    func operationDivide() {
        resultInDouble = Double(number1inString)! / Double(number2inString)!
    }
    
    func addNumber(number: String) {
        if operationIndikator != true {
            number1inString = number1inString + number
            number1inString = deleteFirstZero(number: number1inString)
            printNumberOne()
        } else {
            number2inString = number2inString + number
            number2inString = deleteFirstZero(number: number2inString)
            printNumberTwo()
        }
    }
    
    func printCurrentOperation() {
        guard let currentOperation = currentOperation else {
            return
        }
        askAnswerLabel.text = number1inString + currentOperation.rawValue
    }
    
    func addPoint(number: String) -> String {
        guard !number.contains(".") else {
            return number
        }
        if !number.isEmpty {
            return number + "."
        } else {
            return "0."
        }
    }
    
    func deleteSymbol(operationString: String) -> String {
        var resultString = operationString
        resultString.remove(at: operationString.index(before: operationString.endIndex))
        return resultString
    }
    
    func printNumberOne() {
        askAnswerLabel.text = number1inString
    }
    func printNumberTwo() {
        guard let currentOperation = currentOperation else {
            return
        }
        askAnswerLabel.text = number1inString + currentOperation.rawValue + number2inString
    }
    
    func deleteFirstZero(number: String) -> String {
        let firstNumber = number[number.startIndex]
        guard firstNumber == "0", !number.contains("."), number.count > 1 else {
            return number
        }
        var numberNew = number
        numberNew.remove(at: numberNew.startIndex)
        return numberNew
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            askAnswerLabel.text = "Задайте операцию."
        }
        askAnswerLabel.text = String(resultInDouble)
        number1inString = String(resultInDouble)
        number2inString = ""
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
        number1inString = ""
        number2inString = ""
        resultInDouble = 0
        operationIndikator = false
        currentOperation = nil
        askAnswerLabel.text = "0"
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
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewControllerID") as! SecondViewController
        newView.result = String(resultInDouble)
        self.navigationController?.pushViewController(newView, animated: true)
    }
}
