//
//  ViewController.swift
//  Public_key_ciphers
//
//  Created by Kiryl Holubeu on 10/7/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa

extension NSViewController {
    func browseFile() -> String {
        let browse = NSOpenPanel();
        browse.title                   = "Choose a file"
        browse.showsResizeIndicator    = true
        browse.showsHiddenFiles        = false
        browse.canCreateDirectories    = true
        browse.allowsMultipleSelection = false
        
        if (browse.runModal() == NSApplication.ModalResponse.OK) {
            let result = browse.url
            if (result != nil) {
                return result!.path
            }
        }
        return ""
    }
    
    func dialogError(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
}

class ViewController: NSViewController {
    
    var outputBuff: [UInt16] = []
    var inputBuff: [UInt8] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func openFilePKC(inputField: inout NSTextField, outputField: inout NSTextField, sender: NSButton) {
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
                var buffer = [UInt8](repeating: 0, count: data.length)
                data.getBytes(&buffer, length: data.length)
                var tempbuffer: [UInt16] = []
                for i in 0..<buffer.count/2 - 1 {
                    var tempUInt16: UInt16 = 0
                    var k = 0
                    for j: UInt in [8,0] {
                        let temp = UInt16(buffer[i*2+k])
                        tempUInt16 += (temp << j)
                        k += 1
                    }
                    tempbuffer.append(tempUInt16)
                }
                outputBuff = tempbuffer
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
    
    func saveFilePKC(sender: NSButton) {
        let filePath = browseFile()
        if filePath != "" {
            switch sender.tag {
            case 0:
                let pointer = UnsafeBufferPointer(start: inputBuff, count: inputBuff.count)
                let data = Data(buffer: pointer)
                try! data.write(to: URL(fileURLWithPath: filePath))
            case 1:
                var buffer: [UInt8] = []
                for int in outputBuff {
                    for i: UInt in [8,0] {
                        let temp = (int >> i) & 255
                        buffer.append(UInt8(temp))
                    }
                }
                let pointer = UnsafeBufferPointer(start: buffer, count: buffer.count)
                let data = Data(buffer: pointer)
                try! data.write(to: URL(fileURLWithPath: filePath))
            default:
                break
            }
        }
    }
    
}

