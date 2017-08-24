//
//  ViewController.swift
//  Calculator
//
//  Created by Michael on 7/18/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
var ddgg = 2
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  //  @IBOutlet weak var normalX: UIButton!
    @IBOutlet weak var radbut: UIButton!
    @IBOutlet weak var yMax: UITextField!
    @IBOutlet weak var yMin: UITextField!
    @IBOutlet weak var xMax: UITextField!
    @IBOutlet weak var xMin: UITextField!
    @IBOutlet weak var graphPannel: UIView!
    @IBOutlet weak var calcSymbol: UILabel!
    @IBOutlet weak var calcX: UIButton!
    @IBOutlet weak var calcExpression: UITextField!
    @IBOutlet weak var calcLowerBound: UITextField!
    @IBOutlet weak var calcUpperBound: UITextField!
    @IBOutlet weak var display2: UITextView!
    @IBOutlet weak var display: UITextView!
    @IBOutlet weak var rad: UILabel!
    var ans = 0.0
    var ass = ""//kkkjoi
    var graphSwith = false{
        didSet{
            graphPannel.isHidden = !graphSwith
        }
    }
  //  let calcN = 8000
    var calcUpperBoundValue = 0.0
    var calcLowerBoundValue = 0.0
    var calcSwitch = false{
        didSet{
         //   display2.isHidden = calcSwitch
         //   normalX.isHidden = calcSwitch
            display.text = ""
            expressionS = ""
       //     calcX.isHidden = !calcSwitch
            calcUpperBound.isHidden = !calcSwitch
            calcLowerBound.isHidden = !calcSwitch
            calcExpression.isHidden = !calcSwitch
            calcSymbol.isHidden = !calcSwitch
        }
    }
    
    var expressionHistory = [""]
    var buttons = [UIButton]()
    var expressionS: String = ""{
        didSet{
            if calcSwitch == false{
                display.text = expressionS}
            calcExpression.text = expressionS
        }
    }
    var expressionA = [String]()
    var radSwitch:Bool = true{
        didSet{
            rad.isHidden = radSwitch
        }
    }
    var hisStr = ""
    var lBLocation = 0
    var rBLocation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radbut.titleLabel!.text = "rad"
        let path = getDocumentsDirectory().appendingPathComponent(imageName)
        try? background.image = UIImage(contentsOfFile: path.path)
        let filePath:String = NSHomeDirectory() + "/Documents/expressions.txt"
        rad.isHidden = radSwitch
        graphSwith = false
     //   calcX.isHidden = !calcSwitch
        calcExpression.isHidden = !calcSwitch
        calcLowerBound.isHidden = !calcSwitch
        calcUpperBound.isHidden = !calcSwitch
        calcSymbol.isHidden = !calcSwitch
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            buttons.append(btn)
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        if let ooop = try? String(contentsOfFile: filePath){
            expressionHistory = ooop.components(separatedBy: "||")
        }
        for i in (0...expressionHistory.count - 1).reversed() {
            if expressionHistory[i] == ""{
            expressionHistory.remove(at: i)
            }
        }
        for i in expressionHistory{
            hisStr += i
            hisStr += "\n"
        }
        display2.text = hisStr
        display2.scrollRangeToVisible(NSMakeRange((display2.text as NSString).length, 1))
    }
    
    @IBAction func acTapped(_ sender: Any) {
        clearAll()
    }
    
    func buttonTapped(btn: UIButton){
      //  print(expressionA)
        view.endEditing(true)
        parseExpressions(originalExpression: expressionS)
        if expressionA.count >= 1{
            if ((btn.titleLabel!.text! == "( ")||(btn.titleLabel!.text! == "√ ")||(btn.titleLabel!.text! == "sin ")||(btn.titleLabel!.text! == "cos ")||(btn.titleLabel!.text! == "tan ")||(btn.titleLabel!.text! == "arcsin ")||(btn.titleLabel!.text! == "arccos ")||(btn.titleLabel!.text! == "arctan ")||(btn.titleLabel!.text! == "log ")||(btn.titleLabel!.text! == "ln ")||(btn.titleLabel!.text! == "X")||(btn.titleLabel!.text! == "ANS")||(btn.titleLabel!.text! == "e")||(btn.titleLabel!.text! == "π")) && ((isPurnFloat(string: expressionA[expressionA.count - 1])||expressionA[expressionA.count - 1] == ")"||expressionA[expressionA.count - 1] == "2.718281828459"||expressionA[expressionA.count - 1] == "3.1415926535898"||expressionA[expressionA.count - 1] == "\(ans)"||expressionA[expressionA.count - 1] == "X")){
                expressionS += " × "
            }
        if (btn.titleLabel!.text! == "9"||btn.titleLabel!.text! == "8"||btn.titleLabel!.text! == "7"||btn.titleLabel!.text! == "6"||btn.titleLabel!.text! == "5"||btn.titleLabel!.text! == "4"||btn.titleLabel!.text! == "3"||btn.titleLabel!.text! == "2"||btn.titleLabel!.text! == "1"||btn.titleLabel!.text! == "0") && (expressionA[expressionA.count - 1] == "\(ans)"||expressionA[expressionA.count - 1] == "X"||expressionA[expressionA.count - 1] == "2.718281828459"||expressionA[expressionA.count - 1] == "3.1415926535898"||expressionA[expressionA.count - 1] == ")"){
            expressionS += " × "
        }
        if btn.titleLabel!.text! == "X" && expressionA[expressionA.count - 1] == "X"{
            return
            }
        if btn.titleLabel!.text! == "- " && (isPurnFloat(string: expressionA[expressionA.count - 1]) || expressionA[expressionA.count-1] == "X") {
                return
            }
            if btn.titleLabel!.text! == "." && (!isPurnFloat(string: expressionA[expressionA.count - 1]+".2")||expressionA[expressionA.count - 1] == "."){
                return
            }
        }
        
        expressionS += btn.titleLabel!.text!
        parseExpressions(originalExpression: expressionS)
        display.scrollRangeToVisible(NSMakeRange((display.text as NSString).length, 1))
    }
    
    @IBAction func radTapped(_ sender: Any) {
        radSwitch = !radSwitch
        if radSwitch{
            radbut.setTitle("rad", for: UIControlState.normal)
        }
        else{
            radbut.setTitle("RAD", for: UIControlState.normal)
        }
    }
    
    @IBAction func equalsTapped(_ sender: Any) {
        
        
        if (calcSwitch == true){
             if !calcLowerBound.hasText || !calcUpperBound.hasText{
            calcExpression.text = "Type bounds"
            return
        }
            if !isPurnFloat(string: calcLowerBound.text!) || !isPurnFloat(string: calcUpperBound.text!) {
                return
            }
            let lowerBound = calcLowerBound.text!
            let upperBound = calcUpperBound.text!
            calcUpperBoundValue = Double(upperBound)!
            calcLowerBoundValue = Double(lowerBound)!
            let str = "∫ "+expressionS+" ( "+lowerBound+" -> "+upperBound+" )"
            expressionHistory.append(str)}
        else{
            if !radSwitch{expressionHistory.append(expressionS + " (rad)")}
        else{expressionHistory.append(expressionS)}}
        

        
        
        if parseExpressions(originalExpression: expressionS) {
            if calcSwitch == true{
                if calcUpperBoundValue >= calcLowerBoundValue {
                let xGs = [-0.9879925180204850,
               -0.9372733924007060,
               -0.8482065834104270,
               -0.7244177313601700,
               -0.5709721726085380,
               -0.3941513470775630,
               -0.2011940939974340,
               0,
               0.2011940939974340,0.3941513470775630,0.5709721726085380,0.7244177313601700,0.8482065834104270, 0.9372733924007060,
                0.9879925180204850
                ]
                    
                let aGs = [0.0307532419961172,
                0.0703660474881081,
                0.1071592204671710,
                0.1395706779261540,
                0.1662692058169930,
                0.1861610000155620,
                0.1984314853271110,
                0.2025782419255610,
                0.1984314853271110,
                 0.1861610000155620,
                 0.1662692058169930,
                 0.1395706779261540,
                 0.1071592204671710,
                 0.0703660474881081,
                 0.0307532419961172]
                    
                var xValues = [Double]()
                var resultValue = 0.0
                let bMa = calcUpperBoundValue - calcLowerBoundValue
                let bPa = calcLowerBoundValue + calcUpperBoundValue
                let tempArr = expressionA
                var funcValues = [Double]()
                for i in xGs{
                    xValues.append(bMa/2*i+bPa/2)
                }
                for i in xValues{
                    expressionA = tempArr
                    for (index, num) in tempArr.enumerated(){
                        if num != "X"{expressionA[index] = num}
                        else{expressionA[index] = String(i)}
                    }
                    while(true){
                        if (expressionA.count == 1){break}
                        else{
                            calculateExpression(expression: findRootExp(startAt: 0))
                        }
                    }
                funcValues.append(Double(expressionA[0])!)
                }
                for (index,i) in aGs.enumerated(){
                    resultValue += i * funcValues[index]
                }
                resultValue *= bMa/2
                ans = resultValue
                /*
                let stepLength = (calcUpperBoundValue - calcLowerBoundValue)/Double(calcN)
                let tempArr = expressionA
                var resultValue = 0.0
                    for _ in 0...calcN{
                    expressionA = tempArr
                    for (index, num) in tempArr.enumerated(){
                        if num != "X"{expressionA[index] = num}
                        else{expressionA[index] = String(calcLowerBoundValue)}
                    }
                    while(true){
                        if (expressionA.count == 1){break}
                        else{
                           calculateExpression(expression: findRootExp(startAt: 0))
                        }
                    }
                    let leftFoot = expressionA[0]
                    expressionA = tempArr
                    for (index, num) in tempArr.enumerated(){
                        if num != "X"{expressionA[index] = num}
                        else{expressionA[index] = String(calcLowerBoundValue + stepLength)}
                        }
                    while(true){
                        if (expressionA.count == 1){break}
                        else{
                            calculateExpression(expression: findRootExp(startAt: 0))
                        }
                    }
                    let rightFoot = expressionA[0]
             /*       expressionA = tempArr
                    for (index, num) in tempArr.enumerated(){
                            if num != "X"{expressionA[index] = num}
                            else{expressionA[index] = String(calcLowerBoundValue + stepLength/2)}
                        }
                        while(true){
                            if (expressionA.count == 1){break}
                            else{
                                calculateExpression(expression: findRootExp(startAt: 0))
                            }
                        }
                    let midFoot = expressionA[0]*/
                    calcLowerBoundValue += stepLength
                    resultValue += (Double(leftFoot)! + Double(rightFoot)!) * stepLength / 2
                }*/
                    calcExpression.text = expressionS + " = " + String(format: "%.10f",resultValue)
                    expressionHistory[expressionHistory.count-1] += " = " + String(format: "%.10f",resultValue)
                    hisStr = ""
                    for i in expressionHistory{
                        hisStr += i
                        hisStr += "\n"
                    }
                    display2.text = hisStr
                    display2.scrollRangeToVisible(NSMakeRange((display2.text as NSString).length, 1))
                }
                else{calcExpression.text = "Err: Bound value error"}
            }
            else{
                var xContainedSwitch = false
                for i in expressionA{
                    if i == "X"{
                        xContainedSwitch = true
                        
                        
                        let alertController = UIAlertController(title: "X Value",
                                                                message: "Type a value for X", preferredStyle: .alert)
                        alertController.addTextField()
                        let textF = alertController.textFields![0]
                        textF.keyboardType = UIKeyboardType.numbersAndPunctuation
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                            [unowned self] _ in
                            let tempArr = self.expressionA
                            let newName = alertController.textFields![0]
                            self.ass = newName.text!
                            if !self.isPurnFloat(string: self.ass){return}
                            for (index, num) in tempArr.enumerated(){
                                if num == "X"{self.expressionA[index] = self.ass}
                            }
                            //8888888888
                             while(true){
                
                if (self.expressionA.count == 1){break}
                else{
                    self.calculateExpression(expression: self.findRootExp(startAt: 0))
                }
                }
           
            self.ans = Double(self.expressionA[0])!
            self.display.text = self.expressionS + " = " + self.expressionA[0] + " (X = \(self.ass))"
            self.expressionHistory[self.expressionHistory.count-1] += " = \(self.expressionA[0])" + " (X = \(self.ass))"
            
            self.hisStr = ""
            for i in self.expressionHistory{
                self.hisStr += i
                self.hisStr += "\n"
            }
            self.display2.text = self.hisStr
            self.display2.scrollRangeToVisible(NSMakeRange((self.display2.text as NSString).length, 1))
                            let manager = FileManager.default
                            let urlForDocument = manager.urls( for: .documentDirectory,
                                                               in:.userDomainMask)
                            let url = urlForDocument[0]
                            self.createFile(name:"expressions.txt", fileBaseUrl: url)
                            let filePath:String = NSHomeDirectory() + "/Documents/expressions.txt"
                            var strt:String = ""
                            for i in self.expressionHistory{
                                strt += (i + "||")
                            }
                            try! strt.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)   
             //8888888888
                        })
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
                if xContainedSwitch == false{
                    
                while(true){
                    
                    if (expressionA.count == 1){break}
                    else{
                        calculateExpression(expression: findRootExp(startAt: 0))
                    }
                }
                display.text = expressionS + " = " + expressionA[0]
                    print(expressionA[0])
                ans = Double(expressionA[0])!
                expressionHistory[expressionHistory.count-1] += " = \(expressionA[0])"
                hisStr = ""
                for i in expressionHistory{
                    hisStr += i
                    hisStr += "\n"
                }
                display2.text = hisStr
                // display2.setContentOffset(CGPoint(x: 0,y:display2.contentSize.height), animated: true)
                display2.scrollRangeToVisible(NSMakeRange((display2.text as NSString).length, 1))
                }
                
        }
        }
        else{
            display.text = "Err: Incorrect expression"
            calcExpression.text = "Err: Incorrect expression"
        }
       // print(expressionHistory)
        let manager = FileManager.default
        let urlForDocument = manager.urls( for: .documentDirectory,
                                           in:.userDomainMask)
        let url = urlForDocument[0]
        createFile(name:"expressions.txt", fileBaseUrl: url)
        let filePath:String = NSHomeDirectory() + "/Documents/expressions.txt"
        var strt:String = ""
        for i in expressionHistory{
            strt += (i + "||")
        }
        try! strt.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func createFile(name:String, fileBaseUrl:URL){
        let manager = FileManager.default
        
        let file = fileBaseUrl.appendingPathComponent(name)
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
            let _ = manager.createFile(atPath: file.path,contents:data,attributes:nil)
        }
    }
    
    @IBAction func wipeHistoryTapped(_ sender: Any) {
        expressionHistory = [""]
        hisStr = ""
        display2.text = ""
        display2.scrollRangeToVisible(NSMakeRange((display2.text as NSString).length, 1))
        let manager = FileManager.default
        let urlForDocument = manager.urls( for: .documentDirectory,
                                           in:.userDomainMask)
        let url = urlForDocument[0]
        createFile(name:"expressions.txt", fileBaseUrl: url)
        let filePath:String = NSHomeDirectory() + "/Documents/expressions.txt"
        try! "".write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
    }
    @IBAction func delTapped(_ sender: Any) {
        if expressionA.count > 1{
            expressionA.remove(at: expressionA.count - 1)
            var strTemp = expressionA.joined(separator: " ")
            if ((expressionA[expressionA.count - 1] == "+")||(expressionA[expressionA.count - 1] == "－")||(expressionA[expressionA.count - 1] == "×")||(expressionA[expressionA.count - 1] == "÷")||(expressionA[expressionA.count - 1] == "(")||(expressionA[expressionA.count - 1] == "tan")||(expressionA[expressionA.count - 1] == "sin")||(expressionA[expressionA.count - 1] == "cos")||(expressionA[expressionA.count - 1] == "arcsin")||(expressionA[expressionA.count - 1] == "arccos")||(expressionA[expressionA.count - 1] == "arctan")||(expressionA[expressionA.count - 1] == "^")||(expressionA[expressionA.count - 1] == "ln")||(expressionA[expressionA.count - 1] == "log")||(expressionA[expressionA.count - 1] == "-")||(expressionA[expressionA.count - 1] == "√"))
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
        
        
        for i in 0...(expressionA.count-1) {
            /*  if !((num == "1")||(num == "2")||(num == "3")||(num == "4")||(num == "5")||(num == "6")||(num == "7")||(num == "8")||(num == "9")||(num == "."))*/
            switch expressionA[i]{
            case "":
                return false
            case "(":
                lCount += 1
            case ")":
                rCount += 1
            case "ANS":
                expressionA[i] = String(ans)
            case ")(":
                return false
            case "e":
                expressionA[i] = "2.718281828459"
            case "π":
                expressionA[i] = "3.1415926535898"
            case ".":
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
        
        for i in (0...mutableExpression.count - 1).reversed() {
            switch (mutableExpression[i]) {
            case "√":
                index = i
                let resultS = (sqrt(Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "-":
                index = i
                let resultS = (-(Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "^":
                index = i
                let resultS = (pow(Double(mutableExpression[index-1])!,Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression.remove(at: index)
                mutableExpression[index-1] = String(resultS)
            case "sin":
                let resultS:Double
                index = i
                if radSwitch == false { //isRad
                resultS = (sin(Double(mutableExpression[index+1])!))
                }
                else{
                resultS = (sin(Double(mutableExpression[index+1])!/180*Double.pi))
                }
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "cos":
                let resultS:Double
                index = i
                if radSwitch == false { //isRad
                    resultS = (cos(Double(mutableExpression[index+1])!))
                }
                else{
                    resultS = (cos(Double(mutableExpression[index+1])!/180*Double.pi))
                }
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "tan":
                let resultS:Double
                index = i
                if radSwitch == false { //isRad
                    resultS = (tan(Double(mutableExpression[index+1])!))
                }
                else{
                    resultS = (tan(Double(mutableExpression[index+1])!/180*Double.pi))
                }
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "arcsin":
                let resultS:Double
                index = i
                if radSwitch == false { //isRad
                    resultS = (asin(Double(mutableExpression[index+1])!))
                }
                else{
                    resultS = (asin(Double(mutableExpression[index+1])!)/180*Double.pi)
                }
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "arccos":
                let resultS:Double
                index = i
                if radSwitch == false { //isRad
                    resultS = (acos(Double(mutableExpression[index+1])!))
                }
                else{
                    resultS = (acos(Double(mutableExpression[index+1])!)/180*Double.pi)
                }
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "arctan":
                let resultS:Double
                index = i
                if radSwitch == false { //isRad
                    resultS = (atan(Double(mutableExpression[index+1])!))
                }
                else{
                    resultS = (atan(Double(mutableExpression[index+1])!)/180*Double.pi)
                }
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "ln":
                index = i
                let resultS = (log(Double(mutableExpression[index+1])!))
                mutableExpression.remove(at: index+1)
                mutableExpression[index] = String(resultS)
            case "log":
                index = i
                let resultS = (log10(Double(mutableExpression[index+1])!))
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
                
            case "－":
                index = mutableExpression.index(of: "－")!
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
    
    //***************CALC*****************//
    @IBAction func calcTapped(_ sender: Any) {
        calcSwitch = !calcSwitch
           }

    @IBAction func calcExpTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    /************GRAPH*************/
    
    @IBAction func graphTapped(_ sender: Any) {
        view.endEditing(true)
        drawCoordination()
        getFuncPoints()
        graphSwith = true
        (graphPannel as! MyView).setNeedsDisplay()
    }
    
    @IBAction func goTapped(_ sender: Any) {
        view.endEditing(true)
        drawCoordination()
        getFuncPoints()
        (graphPannel as! MyView).setNeedsDisplay()
    }
    
    @IBAction func differentiationTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        view.endEditing(true)
        graphSwith = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upTapped(_ sender: Any) {
        if isPurnFloat(string: yMax.text!) && isPurnFloat(string: yMin.text!){
        yMax.text = String(Double(yMax.text!)! + Double(ViewController.steplengthx[1]))
        yMin.text = String(Double(yMin.text!)! + Double(ViewController.steplengthx[1]))
        view.endEditing(true)
        drawCoordination()
            if ViewController.isFuncGraphable{
                drawDiff()
            }
        getFuncPoints()
        (graphPannel as! MyView).setNeedsDisplay()
        }
    }
    
    @IBAction func downTapped(_ sender: Any) {
        if isPurnFloat(string: yMax.text!) && isPurnFloat(string: yMin.text!){
            yMax.text = String(Double(yMax.text!)! - Double(ViewController.steplengthx[1]))
            yMin.text = String(Double(yMin.text!)! - Double(ViewController.steplengthx[1]))
            view.endEditing(true)
            drawCoordination()
            if ViewController.isFuncGraphable{
                drawDiff()
            }
            getFuncPoints()
            (graphPannel as! MyView).setNeedsDisplay()
        }
    
    }
    
    @IBAction func leftTapped(_ sender: Any) {
        if isPurnFloat(string: yMax.text!) && isPurnFloat(string: yMin.text!){
            xMax.text = String(Double(xMax.text!)! - Double(ViewController.steplengthx[0]))
            xMin.text = String(Double(xMin.text!)! - Double(ViewController.steplengthx[0]))
            view.endEditing(true)
            drawCoordination()
            if ViewController.isFuncGraphable{
                drawDiff()
            }
            getFuncPoints()
            (graphPannel as! MyView).setNeedsDisplay()
        }
    }
    
    @IBAction func rightTapped(_ sender: Any) {
        if isPurnFloat(string: yMax.text!) && isPurnFloat(string: yMin.text!){
            xMax.text = String(Double(xMax.text!)! + Double(ViewController.steplengthx[0]))
            xMin.text = String(Double(xMin.text!)! + Double(ViewController.steplengthx[0]))
            view.endEditing(true)
            drawCoordination()
            if ViewController.isFuncGraphable{
                drawDiff()
            }
            getFuncPoints()
            (graphPannel as! MyView).setNeedsDisplay()
        }
    }
    
    @IBAction func inTapped(_ sender: Any) {
        if isPurnFloat(string: yMax.text!) && isPurnFloat(string: yMin.text!){
            if Double(yMax.text!)!/1.5 >= Double(Int.max) || Double(yMin.text!)!/1.5 <= Double(Int.min) || Double(xMin.text!)!/1.5 <= Double(Int.min) || Double(xMax.text!)!/1.5 >= Double(Int.max) {
                return
            }
            yMax.text = String(format: "%.2f",Double(yMax.text!)! / 1.5 )
            yMin.text = String(format: "%.2f",Double(yMin.text!)! / 1.5 )
            xMax.text = String(format: "%.2f",Double(xMax.text!)! / 1.5 )
            xMin.text = String(format: "%.2f",Double(xMin.text!)! / 1.5 )
            view.endEditing(true)
            drawCoordination()
            if ViewController.isFuncGraphable{
                drawDiff()
            }
            getFuncPoints()
            (graphPannel as! MyView).setNeedsDisplay()
        }
    }
    
    @IBAction func outTapped(_ sender: Any) {
        
        if isPurnFloat(string: yMax.text!) && isPurnFloat(string: yMin.text!){
            if Double(yMax.text!)!*1.5 >= Double(Int.max) || Double(yMin.text!)!*1.5 <= Double(Int.min) || Double(xMin.text!)!*1.5 <= Double(Int.min) || Double(xMax.text!)!*1.5 >= Double(Int.max) {
                return
            }
            yMax.text = String(format: "%.2f",Double(yMax.text!)! * 1.5 )
            yMin.text = String(format: "%.2f",Double(yMin.text!)! * 1.5 )
            xMax.text = String(format: "%.2f",Double(xMax.text!)! * 1.5 )
            xMin.text = String(format: "%.2f",Double(xMin.text!)! * 1.5 )
            view.endEditing(true)
            drawCoordination()
            if ViewController.isFuncGraphable{
                drawDiff()
            }
            getFuncPoints()
            (graphPannel as! MyView).setNeedsDisplay()
        }
    }
    
    
    static var xAxisL = 0.0
    static var yAxisL = 0.0
    static var xCP = [[Double]]()
    static var yCP = [[Double]]()
    static var funcP = [[Double]]()
    static var diffP = [[Double]]()
    static var isFuncGraphable = false
    static var steplengthx = [1,1]
    func drawCoordination(){

        if !xMin.hasText || !xMax.hasText || !yMin.hasText || !yMin.hasText {
            return
        }
        if !isPurnFloat(string: xMin.text!) || !isPurnFloat(string: xMax.text!) || !isPurnFloat(string: yMin.text!) || !isPurnFloat(string: yMax.text!){
            return
        }
        if (Double(xMax.text!)! <= Double(xMin.text!)!) || (Double(yMax.text!)! <= Double(yMin.text!)!){
            return
        }
        ViewController.xCP = []
        ViewController.yCP = []
        ViewController.funcP = []
        ViewController.diffP = []
        
        let xMaxValue = Double(xMax.text!)!
        let xMinValue = Double(xMin.text!)!
        let yMaxValue = Double(yMax.text!)!
        let yMinValue = Double(yMin.text!)!
        var xint = [Double]()
        var yint = [Double]()
        let screen_width = Double(UIScreen.main.bounds.width)
        let screen_height = Double(UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height-70)
        //find x ints
        if Int(xMaxValue) != Int(xMinValue){
            if yMaxValue * yMinValue < 0{
                ViewController.xAxisL = screen_height - screen_height * (0 - yMinValue) / (yMaxValue - yMinValue)
            }
            else{
                if yMinValue < 0{
                    ViewController.xAxisL = 0.0
                }
                else{
                    ViewController.xAxisL = screen_height
                }

            }
            if xMaxValue * xMinValue < 0{
                ViewController.yAxisL = screen_width * (0 - xMinValue) / (xMaxValue - xMinValue)
            }
            else{
                if xMinValue > 0{
                    ViewController.yAxisL = 0.0
                }
                else{
                    ViewController.yAxisL = screen_width
                }
            }
            if xMaxValue - xMinValue > 10{
                xint.append(xMinValue)
                let stepLength = Int((xMaxValue - xMinValue)/10+0.5)
                ViewController.steplengthx[0] = stepLength
                var i = Int(xMinValue + Double(stepLength)+0.5)
                while(Double(i)<xMaxValue){
                    xint.append(Double(i))
                    i+=stepLength
                }
                xint.append(xMaxValue)
                if xint[xint.count-2] > xint[xint.count-1]{
                    xint.remove(at: xint.count-2)
                }
                if (xint[0] > 0 && xint[1]<=xint[0]) || xint[0]==xint[1]{
                    xint.remove(at: 1)
                }
                for i in 0...(xint.count - 1){
                    let length = xMaxValue - xMinValue
                    ViewController.xCP.append([screen_width*(xint[i]-xint[0])/length,xint[i]])
                }

            }
            else{
            xint.append(xMinValue)
            for i in 0...Int(xMaxValue) - Int(xMinValue){
                xint.append(Double(Int(xMinValue)) + Double(i))
            }
            xint.append(xMaxValue)
            if (xint[xint.count-1] < 0 && xint[xint.count-2]>=xint[xint.count-1]) || xint[xint.count-2]==xint[xint.count-1]{
                xint.remove(at: xint.count-2)
            }
            if (xint[0] > 0 && xint[1]<=xint[0]) || xint[0]==xint[1]{
                xint.remove(at: 1)
            }
            for i in 0...(xint.count - 1){
                let length = xMaxValue - xMinValue
                ViewController.xCP.append([screen_width*(xint[i]-xint[0])/length,xint[i]])
            }
            }
        }
        else{
            ViewController.xCP.append([0,Double(xMin.text!)!])
            ViewController.xCP.append([screen_width,Double(xMax.text!)!])
           
        }
        //find y ints
        if Int(yMaxValue) != Int(yMinValue){
            
            if yMaxValue - yMinValue > 10{
                yint.append(yMinValue)
                let stepLength = Int((yMaxValue - yMinValue)/10+0.5)
                ViewController.steplengthx[1] = stepLength
                var i = Int(yMinValue + Double(stepLength)+0.5)
                while(Double(i)<yMaxValue){
                    yint.append(Double(i))
                    i+=stepLength
                }
                yint.append(yMaxValue)
                if yint[yint.count-2] > yint[yint.count-1]{
                    yint.remove(at: yint.count-2)
                }
                if (yint[0] > 0 && yint[1]<=yint[0]) || yint[0]==yint[1]{
                    yint.remove(at: 1)
                }
                for i in 0...(yint.count - 1){
                    let length = yMaxValue - yMinValue
                    ViewController.yCP.append([screen_height - screen_height*(yint[i]-yint[0])/length,yint[i]])
                }
            }
            else{
            yint.append(yMinValue)
            for i in 0...Int(yMaxValue) - Int(yMinValue){
                yint.append(Double(Int(yMinValue)) + Double(i))
            }
            yint.append(yMaxValue)
            if (yint[yint.count-1] < 0 && yint[yint.count-2]>=yint[yint.count-1]) || yint[yint.count-2]==yint[yint.count-1]{
                yint.remove(at: yint.count-2)
            }
            if (yint[0] > 0 && yint[1]<=yint[0]) || yint[0]==yint[1]{
                yint.remove(at: 1)
            }
            for i in 0...(yint.count - 1){
                let length = yMaxValue - yMinValue
                ViewController.yCP.append([screen_height - screen_height*(yint[i]-yint[0])/length,yint[i]])
            }
            }
        }
        else{
            ViewController.yCP.append([screen_height,Double(yMin.text!)!])
            ViewController.yCP.append([0,Double(yMax.text!)!])
            
        }
                }

    func getFuncPoints() -> Bool{
        if !xMin.hasText || !xMax.hasText || !yMin.hasText || !yMin.hasText {
            return false
        }
        if !isPurnFloat(string: xMin.text!) || !isPurnFloat(string: xMax.text!) || !isPurnFloat(string: yMin.text!) || !isPurnFloat(string: yMax.text!){
            return false
        }
        if (Double(xMax.text!)! <= Double(xMin.text!)!) || (Double(yMax.text!)! <= Double(yMin.text!)!){
            return false
        }
        let xMaxValue = Double(xMax.text!)!
        let xMinValue = Double(xMin.text!)!
        let yMaxValue = Double(yMax.text!)!
        let yMinValue = Double(yMin.text!)!
        if !parseExpressions(originalExpression: expressionS){return false}
        var xValues = [Double]()
        var yValues = [Double]()
        let screen_width = Double(UIScreen.main.bounds.width)
        let screen_height = Double(UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height-70)
        let stepLength = (xMaxValue - xMinValue)/screen_width
        for i in 0...Int(screen_width){
            xValues.append(xMinValue + Double(i) * stepLength)
        }
        
        for i in xValues{
            let tempArr = expressionA
            for (index, num) in tempArr.enumerated(){
                if num != "X"{expressionA[index] = num}
                else{expressionA[index] = String(i)}
            }
            while(true){
                if (expressionA.count == 1){break}
                else{
                    calculateExpression(expression: findRootExp(startAt: 0))
                }
            }
            yValues.append(Double(expressionA[0])!)
            expressionA = tempArr
        }
        for i in 0...(xValues.count - 1){
            ViewController.funcP.append([(xValues[i]-xMinValue)/(xMaxValue-xMinValue)*screen_width,screen_height-((yValues[i]-yMinValue)/(yMaxValue-yMinValue)*screen_height)])
        }
        
        return true
    }
    
    func drawDiff(){
        if !xMin.hasText || !xMax.hasText || !yMin.hasText || !yMin.hasText {
            return
        }
        if !isPurnFloat(string: xMin.text!) || !isPurnFloat(string: xMax.text!) || !isPurnFloat(string: yMin.text!) || !isPurnFloat(string: yMax.text!){
            return
        }
        if (Double(xMax.text!)! <= Double(xMin.text!)!) || (Double(yMax.text!)! <= Double(yMin.text!)!){
            return
        }
        let xMaxValue = Double(xMax.text!)!
        let xMinValue = Double(xMin.text!)!
        let yMaxValue = Double(yMax.text!)!
        let yMinValue = Double(yMin.text!)!
        if !parseExpressions(originalExpression: expressionS){return}
        var xValues = [Double]()
        var yValues = [Double]()
        let screen_width = Double(UIScreen.main.bounds.width)
        let screen_height = Double(UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height-70)
        let stepLength = (xMaxValue - xMinValue)/screen_width
        for i in 0...Int(screen_width){
            xValues.append(xMinValue + Double(i) * stepLength)
        }
        
        for i in xValues{
            let tempArr = expressionA
            for (index, num) in tempArr.enumerated(){
                if num != "X"{expressionA[index] = num}
                else{expressionA[index] = String(i)}
            }
            while(true){
                if (expressionA.count == 1){break}
                else{
                    calculateExpression(expression: findRootExp(startAt: 0))
                }
            }
            yValues.append(Double(expressionA[0])!)
            expressionA = tempArr
        }
        for i in 0...(yValues.count - 2){
            yValues[i] = (yValues[i+1]-yValues[i])/stepLength
        }
        
        yValues.remove(at: yValues.count-1)
        xValues.remove(at: xValues.count-1)
        
        for i in 0...(xValues.count - 1){
            ViewController.diffP.append([(xValues[i]-xMinValue)/(xMaxValue-xMinValue)*screen_width,screen_height-((yValues[i]-yMinValue)/(yMaxValue-yMinValue)*screen_height)])
        }
        return

    }
    
    @IBAction func drawDiffTapped(_ sender: Any) {
        view.endEditing(true)
        drawCoordination()
        getFuncPoints()
        drawDiff()
        ViewController.isFuncGraphable = !(ViewController.isFuncGraphable)
         (graphPannel as! MyView).setNeedsDisplay()
    }
    
    @IBAction func endEditTapped(_ sender: Any) {
        view.endEditing(true)
    }
    //********change background******//
    let imageName = "background"
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    @IBOutlet weak var background: UIImageView!
    
    @IBAction func changeBgTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        var gaussImage:UIImage
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        let inputImage =  CIImage(image: image)
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        filter.setValue(30, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: image.size)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        gaussImage = UIImage(cgImage: cgImage!)
        if let jpegData = UIImageJPEGRepresentation(gaussImage, 20) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let path = getDocumentsDirectory().appendingPathComponent(imageName)
        try? background.image = UIImage(contentsOfFile: path.path)
        
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}


class MyView: UIView {
    let screen_width = Double(UIScreen.main.bounds.width)
    let screen_height = Double(UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height-70)
    
    override func draw(_ rect: CGRect) {
        var zeroLocation = [ViewController.xAxisL,ViewController.yAxisL]
        let context:CGContext =  UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true) //抗锯齿设置
        //draw xy-coordination
     /*   for (index,i) in ViewController.yCP.enumerated(){
            if i[1] == 0.0{
                ViewController.xAxisL = i[0]
                zeroLocation[1] = i[0]
                ViewController.yCP.remove(at: index)
            }
        }
        for (index,i) in ViewController.xCP.enumerated(){
            if i[1] == 0.0{
                ViewController.yAxisL = i[0]
                zeroLocation[0] = i[0]
                ViewController.xCP.remove(at: index)
            }
        }*/
        //cut redundant points
    /*    if (ViewController.xCP.count - 2) > 10{
            var tempArr = [[Double]]()
            tempArr.append(ViewController.xCP[0])
            let need = Int(Double((ViewController.xCP.count - 2) / 10) + 0.5)
            ViewController.steplengthx[0] = need
            var i = 1
            while(i < ViewController.xCP.count){
                tempArr.append(ViewController.xCP[i])
                i += need
            }
            ViewController.xCP = tempArr
        }
        if (ViewController.yCP.count - 2) > 10{
            var tempArr = [[Double]]()
            tempArr.append(ViewController.yCP[0])
            let need = Int(Double((ViewController.yCP.count - 2) / 10) + 0.5)
            ViewController.steplengthx[1] = need
            var i = 1
            while(i < ViewController.yCP.count){
                tempArr.append(ViewController.yCP[i])
                i += need
            }
            ViewController.yCP = tempArr
        }*/
      //  print(ViewController.yCP)
        //x
        context.setStrokeColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1 )
        context.setLineWidth(2)
        context.move(to: CGPoint(x: 0, y: ViewController.xAxisL))
        context.addLine(to: CGPoint(x: screen_width, y: ViewController.xAxisL))
        context.strokePath();
        //y
        context.setStrokeColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1 )
        context.setLineWidth(2)
        context.move(to: CGPoint(x: ViewController.yAxisL, y: 0))
        context.addLine(to: CGPoint(x: ViewController.yAxisL, y: screen_height))
        context.strokePath();
        
        //draw points
     //   "0".draw(at: CGPoint(x: (zeroLocation[0] + 5), y: zeroLocation[1]), withAttributes: nil )
        context.setLineWidth(3)
        var counter = 0
        for i in ViewController.xCP{
            context.move(to: CGPoint(x: i[0], y: ViewController.xAxisL))
            context.addLine(to: CGPoint(x: i[0], y: (ViewController.xAxisL + 3)))
            if (counter % 2) != 0{
                String(i[1]).draw(at: CGPoint(x: i[0]-8, y: ViewController.xAxisL-15), withAttributes: nil )}
            else{
                String(i[1]).draw(at: CGPoint(x: i[0]-8, y: ViewController.xAxisL), withAttributes: nil )}
            
            counter += 1
        }
        counter = 0
        for i in ViewController.yCP{
            context.move(to: CGPoint(x: ViewController.yAxisL, y: i[0]))
            context.addLine(to: CGPoint(x: (ViewController.yAxisL + 3), y: i[0]))
            if (counter % 2) != 0{
                String(i[1]).draw(at: CGPoint(x: ViewController.yAxisL-20, y: i[0]-5), withAttributes: nil )}
            else{ String(i[1]).draw(at: CGPoint(x: ViewController.yAxisL+5, y: i[0]-5), withAttributes: nil )
                }
            counter += 1
           
        }
        context.strokePath();
        
        //draw functions
        context.setLineWidth(1)
        if ViewController.funcP.count > 2{
        for i in 0...(ViewController.funcP.count - 2){
            context.move(to: CGPoint(x: ViewController.funcP[i][0], y: ViewController.funcP[i][1]))
            context.addLine(to: CGPoint(x: ViewController.funcP[i+1][0], y: ViewController.funcP[i+1][1]))
        }
        context.strokePath();
        }
        //draw differentials
        if ViewController.isFuncGraphable{
        
        if ViewController.diffP.count > 2{
            
            for i in 0...(ViewController.diffP.count - 2){
                context.setStrokeColor(red: 255, green: 0.5, blue: 0.5, alpha: 1 )
                context.move(to: CGPoint(x: ViewController.diffP[i][0], y: ViewController.diffP[i][1]))
                context.addLine(to: CGPoint(x: ViewController.diffP[i+1][0], y: ViewController.diffP[i+1][1]))
            }
        }
            
            context.strokePath();
        }
    }
    
}

