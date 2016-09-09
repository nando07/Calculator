//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Fernando Gomez on 9/7/16.
//  Copyright © 2016 Nando. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var runningNumber = ""
    var currentOperation = Operation.Empty
    var leftValStr : String? = ""
    var rightValStr : String? = ""
    var result = ""
    var btnSound : AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay() {
            
            catch let err as NSError {
            print(err.debugDescription)
        }
        outputLbl.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
        
        print("Opereation: \(currentOperation)")
        print("Left Value: \(leftValStr)")
        print("Right Value: \(rightValStr)")
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
        print("Opereation: \(currentOperation)")
        print("Left Value: \(leftValStr)")
        print("Right Value: \(rightValStr)")
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        
        /* if there is not right and left values, then no matter
           how many times user taps the operators,currentOperator 
           must remain "empty" */
        
        if rightValStr == "" && leftValStr == "" {
            currentOperation = .Empty
        }
        processOperation(operation: currentOperation)
        print("Opereation: \(currentOperation)")
        print("Left Value: \(leftValStr)")
        print("Right Value: \(rightValStr)")
        
        
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        playSound()
        clear()
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation : Operation) {
        playSound()
        if currentOperation != Operation.Empty && leftValStr != "" {
            
            // user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                
                rightValStr = runningNumber
                runningNumber = ""
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr!)! * Double(rightValStr!)!)"
                    
                }else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr!)! / Double(rightValStr!)!)"
                    
                }else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr!)! - Double(rightValStr!)!)"
                    
                }else if currentOperation ==
                    Operation.Add {
                    result = "\(Double(leftValStr!)! + Double(rightValStr!)!)"
                    
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = operation
            
        } else {
            // first time an operator has been pressed
            
            leftValStr = runningNumber
            currentOperation = operation
    
            // This prevents crash if users tap the equal sign many times before choosing  an operator
            if leftValStr != "" && currentOperation != .Empty {
                runningNumber = ""
            }
        }
    }
    
    func clear() {
        runningNumber = ""
        currentOperation = Operation.Empty
        leftValStr = ""
        rightValStr = ""
        result = ""
        outputLbl.text = "0"
    }
}

