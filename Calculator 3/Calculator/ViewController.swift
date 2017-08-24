//
//  ViewController.swift
//  Calculator
//
//  Created by Michael on 7/18/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var buttons = [UIButton]()
    var expressionS: String = ""{
        didSet{
            display.text = expressionS
        }
    }
    var expressionANS:NSArray = [""]
    var expressionA = [String]()
    var operatorLocations = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            buttons.append(btn)
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func acTapped(_ sender: Any) {
        expressionS = ""
        expressionA = [""]
        operatorLocations = []
    }
    
    func buttonTapped(btn: UIButton){
        expressionS += btn.titleLabel!.text!
    }
    
    @IBAction func equalsTapped(_ sender: Any) {
        if parseExpressions(originalExpression: expressionS) {
        
        display.text = "\(calculateExpression(num1: expressionA[0], num2: expressionA[2], operator1: expressionA[1])) "//    \(expressionA[1])      \(expressionA[2])
        }
        else{
            display.text = "Err"
        }
    }
    
    func parseExpressions(originalExpression: String) -> Bool{
      //  expressionANS = expressionA as NSArray
            expressionA = [""]
            operatorLocations = []

        expressionA = originalExpression.components(separatedBy: " ")
        for (index,num) in expressionA.enumerated() {
          /*  if !((num == "1")||(num == "2")||(num == "3")||(num == "4")||(num == "5")||(num == "6")||(num == "7")||(num == "8")||(num == "9")||(num == "."))*/
            if num == ""
            { return false}
            if ((num == "+")||(num == "-")||(num == "×")||(num == "÷"))
           {
              operatorLocations.append(index)
            }
        }
        return true
    }

    func calculateExpression(num1: String, num2: String, operator1: String) -> Double{
        switch (operator1) {
            case "+":
            return (Double(num1)! + Double(num2)!)
            case "-":
            return (Double(num1)! - Double(num2)!)
            case "×":
            return (Double(num1)! * Double(num2)!)
            case "÷":
            return (Double(num1)! / Double(num2)!)
            default: break
        }
        return 0.0
    }
 /*   func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

