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
    var radSwitch:Bool = false
    var lBLocation = 0
    var rBLocation = 0
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
        clearAll()
    }
    
    func buttonTapped(btn: UIButton){
        if expressionA.count > 1{
        if ((btn.titleLabel!.text! == "( ")||(btn.titleLabel!.text! == "√ ")||(btn.titleLabel!.text! == "sin ")||(btn.titleLabel!.text! == "cos ")||(btn.titleLabel!.text! == "tan ")||(btn.titleLabel!.text! == "arcsin ")||(btn.titleLabel!.text! == "arccos ")||(btn.titleLabel!.text! == "arctan ")) && isPurnFloat(string: expressionA[expressionA.count - 1]){
        expressionS += " × "
            }}
        expressionS += btn.titleLabel!.text!
        parseExpressions(originalExpression: expressionS)
    }
    
    @IBAction func equalsTapped(_ sender: Any) {
        if parseExpressions(originalExpression: expressionS) {
        while(true){
            if (expressionA.count == 1){break}
            else{
                calculateExpression(expression: findRootExp(startAt: 0))
            }
         }
        display.text = expressionA[0]
        }
        else{
            display.text = "Err"
        }
    }
    
    @IBAction func delTapped(_ sender: Any) {
        if expressionA.count > 1{
        expressionA.remove(at: expressionA.count - 1)
        var strTemp = expressionA.joined(separator: " ")
        if ((expressionA[expressionA.count - 1] == "+")||(expressionA[expressionA.count - 1] == "-")||(expressionA[expressionA.count - 1] == "×")||(expressionA[expressionA.count - 1] == "÷")||(expressionA[expressionA.count - 1] == "("))
        {
            strTemp += " "
        }
            expressionS = strTemp
        }
        else{
            clearAll()
        }
    }
    
    func clearAll(){
        expressionS = ""
        expressionA = []

    }
    
    func findRootExp(startAt: Int) -> Array<String> {
        var leftBracketLocation = -1
        var rightBracketLocation = -1
        var lLeftBracketLocation = -1
        lBLocation = 0
        rBLocation = 0
        var resultArray = [String]()
        for (index,num) in expressionA.enumerated() {
            if (num == "(") && (index >= startAt) {
                leftBracketLocation = index
                break
            }
        }
        if leftBracketLocation == -1{
            for (index,num) in expressionA.enumerated() {
                if ((num == ")") && (index > leftBracketLocation)){
                    rightBracketLocation = index
                    return ["only right bracket"]
                }
            }
            if rightBracketLocation == -1{
                lBLocation = 0
                rBLocation = expressionA.count - 1
                return expressionA}
        }

        for (index,num) in expressionA.enumerated() {
            if ((num == ")") && (index > leftBracketLocation)){
                rightBracketLocation = index
                break
            }
        }
        if rightBracketLocation == -1{return ["rightBracketnotfound", "\(leftBracketLocation)"]}
        
        for (index,num) in expressionA.enumerated() {
            if (num == "(") && (index > leftBracketLocation){
                lLeftBracketLocation = index
                break
            }
        }
        if lLeftBracketLocation == -1{
            for i in (leftBracketLocation + 1)...(rightBracketLocation - 1){
                resultArray.append(expressionA[i])
            }
            lBLocation = leftBracketLocation
            rBLocation = rightBracketLocation
            return resultArray
        }
        
        if rightBracketLocation < lLeftBracketLocation{
            for i in (leftBracketLocation + 1)...(rightBracketLocation - 1){
                resultArray.append(expressionA[i])
            }
            lBLocation = leftBracketLocation
            rBLocation = rightBracketLocation
            return resultArray
        }
        else{
            return findRootExp(startAt: lLeftBracketLocation)
        }
    }

  
    
    func parseExpressions(originalExpression: String) -> Bool{
      //  expressionANS = expressionA as NSArray
        expressionA = []
        var lCount = 0
        var rCount = 0
        
            expressionA = originalExpression.components(separatedBy: " ")
        
        for num in expressionA {
          /*  if !((num == "1")||(num == "2")||(num == "3")||(num == "4")||(num == "5")||(num == "6")||(num == "7")||(num == "8")||(num == "9")||(num == "."))*/
            switch num{
            case "":
             return false
            case "(":
              lCount += 1
            case ")":
                rCount += 1
            case ")(":
                return false
            default:
                break
            }
        }
        if lCount == rCount {return true}
        else {return false}
    }
    
    func calculateExpression(expression: Array<String>) -> Double{
        var index:Int = 0
        var mutableExpression = expression
        
        for operator1 in mutableExpression {
            switch (operator1) {
            case "√":
                index = mutableExpression.index(of: "√")!
                let resultS = (sqrt(Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "^":
                index = mutableExpression.index(of: "^")!
                let resultS = (pow(Double(mutableExpression[index-1])!,Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression.remove(at: index)
                mutableExpression[index-1] = String(resultS)
            case "sin":
                index = mutableExpression.index(of: "sin")!
                let resultS = (sin(Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            default: break
            }
        }
        
        for operator1 in mutableExpression {
            switch (operator1) {
            case "×":
                index = mutableExpression.index(of: "×")!
                let resultS = (Double(mutableExpression[index-1])! * Double(mutableExpression[index+1])!)
                mutableExpression.remove(at: index+1)
                mutableExpression.remove(at: index)
                mutableExpression[index-1] = String(resultS)
                
            case "÷":
                index = mutableExpression.index(of: "÷")!
                let resultS = (Double(mutableExpression[index-1])! / Double(mutableExpression[index+1])!)
                mutableExpression.remove(at: index+1)
                mutableExpression.remove(at: index)
                mutableExpression[index-1] = String(resultS)
            default: break
            }
        }
        
        for operator1 in mutableExpression {
            switch (operator1) {
            case "+":
                index = mutableExpression.index(of: "+")!
                let resultS = (Double(mutableExpression[index-1])! + Double(mutableExpression[index+1])!)
                mutableExpression.remove(at: index+1)
                mutableExpression.remove(at: index)
                mutableExpression[index-1] = String(resultS)
                
            case "-":
                index = mutableExpression.index(of: "-")!
                let resultS = (Double(mutableExpression[index-1])! - Double(mutableExpression[index+1])!)
                mutableExpression.remove(at: index+1)
                mutableExpression.remove(at: index)
                mutableExpression[index-1] = String(resultS)
            default: break
            }
        }
        expressionA[lBLocation] = mutableExpression[0]
        for i in ((lBLocation + 1)...rBLocation).reversed() {
            expressionA.remove(at: i)
        }
        return Double(mutableExpression[0])!
    }
    
    func isPurnFloat(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Float = 0
        
        return scan.scanFloat(&val) && scan.isAtEnd
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

