//
//  RSAViewController.swift
//  Public_key_ciphers
//
//  Created by Kiryl Holubeu on 10/7/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa


class RSAViewController: NSViewController  {

    @IBOutlet weak var pTBox: NSTextField!
    @IBOutlet weak var qTBox: NSTextField!
    @IBOutlet weak var kcTBox: NSTextField!
    @IBOutlet weak var rTBox: NSTextField!
    @IBOutlet weak var eulerTBox: NSTextField!
    @IBOutlet weak var koTBox: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    @IBOutlet weak var outputField: NSTextField!
    
    var p = 0
    var q = 0
    var kc = 0
    var r = 0
    var euler = 0
    var ko = 0
    var outputBuff: [Int] = []
    var inputBuff: [UInt8] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func encode() {
        outputBuff = inputBuff.map { Int($0) }
        for index in 0..<outputBuff.count {
            outputBuff[index] = fastexp(a: Int(outputBuff[index]), z: kc, n: r)
        }
        outputField.stringValue = ""
        for operatedByte in outputBuff {
            outputField.stringValue.append(String(operatedByte) + " ")
        }
    }
    
    func decode() {
        inputBuff.removeAll()
        for operatedByte in outputBuff {
            inputBuff.append(UInt8(fastexp(a: Int(operatedByte), z:kc, n: r)))
        }
    }
    
    func allValuesIsOkey(tag: Int) -> Bool {
        switch tag {
        case 0:
            guard inputBuff.count > 0 else {
                dialogError(question: "Error!", text: "Please, open a file first.")
                return false
            }
            
        case 1:
            guard outputBuff.count > 0 else {
                dialogError(question: "Error!", text: "Please, open a file first.")
                return false
            }
            
        default:
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
        
        guard (Int(kcTBox.stringValue) != nil) else {
            dialogError(question: "Error!", text: "Kc is not a number.")
            return false
        }
        kc = Int(kcTBox.stringValue)!
        
        euler  = (p - 1) * (q - 1)
        eulerTBox.stringValue = String(euler)
        r = p * q
        rTBox.stringValue = String(r)
        
        guard isRelativelyPrime(kc, euler) else {
            dialogError(question: "Error!", text: "Incorrected Kc.")
            return false
        }
        
        ko = inverseIt(kc, euler)
        koTBox.stringValue = String(ko)
        
        switch tag {
        case 0:
            encode()

        case 1:
            decode()
        default:
            break
        }
        
        return true
    }
    
    @IBAction func encodeRSA(_ sender: NSButton) {
        if allValuesIsOkey(tag: sender.tag) {
            
        }
    }
    
    @IBAction func decodeRSA(_ sender: NSButton) {
        if allValuesIsOkey(tag: sender.tag) {
            
        }
    }
    
    @IBAction func openFile(_ sender: NSButton) {
        let filePath = browseFile()
        if let data = NSData(contentsOfFile: filePath) {
            switch sender.tag {
            case 0:
                var buffer = [UInt8](repeating: 0, count: data.length)
                data.getBytes(&buffer, length: data.length)
                inputBuff = buffer
                inputField.stringValue = ""
                for byte in inputBuff {
                    inputField.stringValue.append(String(byte) + " ")
                    if inputField.stringValue.count > 1300 {
                        break
                    }
                }
            case 1:
                var buffer = [Int](repeating: 0, count: data.length / 8)
                data.getBytes(&buffer, length: data.length)
                outputBuff = buffer
                outputField.stringValue = ""
                for byte in outputBuff {
                    outputField.stringValue.append(String(byte) + " ")
                    if outputField.stringValue.count > 1300 {
                        break
                    }
                }
            default:
                break
            }
        }
    }

    @IBAction func safeFile(_ sender: NSButton) {
        let filePath = browseFile()
        if filePath != "" {
            let outputStream = OutputStream(toFileAtPath: filePath, append: false)!
            switch sender.tag {
            case 0:
                let pointer = UnsafeBufferPointer(start: inputBuff, count: inputBuff.count)
                let data = Data(buffer: pointer)
                try! data.write(to: URL(fileURLWithPath: filePath + ".decoded"))
            case 1:
                var buffer: [UInt8] = []
                for int in outputBuff {
                    for i: UInt in [56,48,40,32,24,16,8,0] {
                        let temp = (int >> i) & 255
                        buffer.append(UInt8(temp))
                    }
                }
                outputStream.open()
                outputStream.write(buffer, maxLength: outputBuff.count)
                outputStream.close()
            default:
                break
            }
        }
    }
    
}
