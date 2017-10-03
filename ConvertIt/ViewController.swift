//
//  ViewController.swift
//  ConvertIt
//
//  Created by Arya Murthi on 9/29/17.
//  Copyright © 2017 Arya Murthi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    struct Formula{
        var conversionString: String!
        var formula: (Double) -> Double
    }
    
    
    //MARK:- Variables
    let formulasArray = [Formula(conversionString:"Miles to Kilometers", formula: {$0/0.62137}),
                        Formula(conversionString:"Kilometers to Miles", formula: {$0*0.62137}),
                        Formula(conversionString:"Feet to Meters", formula: {$0/3.2808}),
                        Formula(conversionString:"Yards to Meters", formula: {$0/1.0936}),
                        Formula(conversionString:"Meters to Feet", formula: {$0*3.2808}),
                        Formula(conversionString:"Meters to Yards", formula: {$0*0.62137}),
                        Formula(conversionString:"in to cm", formula: {$0/0.3937}),
                        Formula(conversionString:"cm to in", formula: {$0*0.3937}),
                        Formula(conversionString:"Fahrenheit to Celcius", formula: {($0-32) * (5/9)}),
                        Formula(conversionString:"Celcius to Fahrenheit", formula: {($0 * (9/5)) + 32}),
                        Formula(conversionString:"Quarts to Liters", formula: {$0*1.05669}),
                        Formula(conversionString:"Liters to Quarts", formula: {$0*0.62137})]
    
    
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    var formatSegment = 0
    var rowSelected = 0
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
        
        //hideKeyboardWhenTappedAround
        
        conversionString = formulasArray[0].conversionString
        let unitsArray = conversionString.components(separatedBy: " to ")
        
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        
        signSegment.isHidden = true
        
    }
    
    
    func calculateConversion(){
        var outputValue = 0.0
        var outputString = ""
        
        guard let inputValue = Double(userInput.text!) else{
            if userInput.text != "" {
                errorMessage(message: "Invalid input number", title: "ERROR")
            }
            return
        }
        
        outputValue = formulasArray[rowSelected].formula(inputValue)
        
        let segmentedIndex = decimalSegment.selectedSegmentIndex
        let formatString = (segmentedIndex < 3 ? "%.\(segmentedIndex+1)f" : "%.f")
         outputString = String(format: formatString, outputValue)
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
        
    }
    func errorMessage(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        present(alertController, animated:true, completion: nil)
        
        alertController.addAction(defaultAction)
    }
    

    //MARK:- IBActions
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userInput.text?.first == "-"{
            signSegment.selectedSegmentIndex = 1
        }else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    @IBAction func convertButtonPressed(_ sender: UIButton){
        calculateConversion()
    }
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConversion()
    }
    @IBAction func signSegmentSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        
        if userInput.text != "-" {
            calculateConversion()
        }
        
    }
}
//MARK:- extensions
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulasArray[row].conversionString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        rowSelected = row
        
        conversionString = formulasArray[row].conversionString
        if conversionString.contains("Celcius") || conversionString.contains("Fahrenheit"){
            signSegment.isHidden = false
        }else {
            signSegment.isHidden = true
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
        }
        let unitsArray = conversionString.components(separatedBy: " to ")
        
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        
        fromUnitsLabel.text = fromUnits
        resultsLabel.text = toUnits
        
    }
}

//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

