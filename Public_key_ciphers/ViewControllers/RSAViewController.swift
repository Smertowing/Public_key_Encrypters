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
    var e = 0
    var outputBuff: [Int] = []
    var inputBuff: [UInt8] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard (Int(kcTBox.stringValue) != nil) && (Int(kcTBox.stringValue)!.isPrime) else {
            dialogError(question: "Error!", text: "q is not a prime number.")
            return false
        }
        kc = Int(kcTBox.stringValue)!
        
        return true
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
    
    @IBAction func encodeRSA(_ sender: NSButton) {
        if allValuesIsOkey(tag: sender.tag) {
            encode()
        }
    }
    
    @IBAction func decodeRSA(_ sender: NSButton) {
        
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
                outputStream.open()
                outputStream.write(inputBuff, maxLength: inputBuff.count)
                outputStream.close()
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
