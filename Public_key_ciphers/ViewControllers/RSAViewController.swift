//
//  RSAViewController.swift
//  Public_key_ciphers
//
//  Created by Kiryl Holubeu on 10/7/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa


class RSAViewController: ViewController  {

    @IBOutlet weak var pTBox: NSTextField!
    @IBOutlet weak var qTBox: NSTextField!
    @IBOutlet weak var kiTBox: NSTextField!
    @IBOutlet weak var rTBox: NSTextField!
    @IBOutlet weak var eulerTBox: NSTextField!
    @IBOutlet weak var koTBox: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    @IBOutlet weak var outputField: NSTextField!
    
    var p = 0
    var q = 0
    var ki = 0
    var r = 0
    var euler = 0
    var ko = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func encode() {
        outputBuff = inputBuff.map { UInt16($0) }
        for index in 0..<outputBuff.count {
            outputBuff[index] = UInt16(fastexp(a: Int(outputBuff[index]), z: ki, n: r))
        }
        outputField.stringValue = ""
        for operatedByte in outputBuff {
            outputField.stringValue.append(String(operatedByte) + " ")
            if outputField.stringValue.count > 1300 {
                break
            }
        }
    }
    
    func decode() {
        inputBuff.removeAll()
        for operatedByte in outputBuff {
            inputBuff.append(UInt8(fastexp(a: Int(operatedByte), z:ko, n: r)))
        }
        inputField.stringValue = ""
        for operatedByte in inputBuff {
            inputField.stringValue.append(String(operatedByte) + " ")
            if inputField.stringValue.count > 1300 {
                break
            }
        }
    }
    
    func allValuesIsOkey(tag: Int) -> Bool {
        switch tag {
        case 0:
            guard inputBuff.count > 0 else {
                dialogError(question: "Error!", text: "Please, open a file first.")
                return false
            }
            
            guard (Int(pTBox.stringValue) != nil) && (Int(pTBox.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "p is not a prime number.")
                return false
            }
            p = Int(pTBox.stringValue)!
            
            guard (Int(qTBox.stringValue) != nil) && (Int(qTBox.stringValue)!.isPrime) else {
                dialogError(question: "Error!", text: "q is not a prime number.")
                return false
            }
            q = Int(qTBox.stringValue)!
            
            guard (Int(kiTBox.stringValue) != nil) else {
                dialogError(question: "Error!", text: "Ki is not a number.")
                return false
            }
            ki = Int(kiTBox.stringValue)!
            
            euler  = (p - 1) * (q - 1)
            eulerTBox.stringValue = String(euler)
            r = p * q
            rTBox.stringValue = String(r)
            guard r >= UInt8.max && r <= UInt16.max else {
                dialogError(question: "Error!", text: "Your primes are very small. N should be at least 255.")
                return false
            }
            guard isRelativelyPrime(ki, euler) else {
                dialogError(question: "Error!", text: "Incorrected Ki.")
                return false
            }
            
            ko = inverseIt(ki, euler)
            koTBox.stringValue = String(ko)
            
        case 1:
            guard outputBuff.count > 0 else {
                dialogError(question: "Error!", text: "Please, open a file first.")
                return false
            }
            
            guard Int(rTBox.stringValue) != nil else {
                dialogError(question: "Error!", text: "r is not a prime number.")
                return false
            }
            r = Int(rTBox.stringValue)!
            guard r >= UInt8.max && r <= UInt16.max else {
                dialogError(question: "Error!", text: "Your primes are very small. N should be at least 255.")
                return false
            }
            
            guard Int(koTBox.stringValue) != nil else {
                dialogError(question: "Error!", text: "r is not a prime number.")
                return false
            }
            ko = Int(koTBox.stringValue)!
            
        default:
            return false
        }
        
        return true
    }
    
    @IBAction func encodeRSA(_ sender: NSButton) {
        if allValuesIsOkey(tag: sender.tag) {
            encode()
        }
    }
    
    @IBAction func decodeRSA(_ sender: NSButton) {
        if allValuesIsOkey(tag: sender.tag) {
            decode()
        }
    }
    
    @IBAction func openFile(_ sender: NSButton) {
        openFilePKC(inputField: &inputField, outputField: &outputField, sender: sender)
    }
    
    @IBAction func safeFile(_ sender: NSButton) {
        saveFilePKC(sender: sender)
    }
    
}
