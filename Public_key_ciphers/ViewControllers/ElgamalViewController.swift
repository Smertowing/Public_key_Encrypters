//
//  Elgamal.swift
//  Public_key_ciphers
//
//  Created by Kiryl Holubeu on 10/11/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa

class ElgamalViewController: ViewController {
    
    @IBOutlet weak var pTBox: NSTextField!
    @IBOutlet weak var xTBox: NSTextField!
    @IBOutlet weak var kTBox: NSTextField!
    @IBOutlet weak var gTBox: NSTextField!
    @IBOutlet weak var yTBox: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    @IBOutlet weak var outputField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func encodeElgamal(_ sender: NSButton) {

    }
    
    @IBAction func decodeElgamal(_ sender: NSButton) {
     
    }
    
    @IBAction func openFile(_ sender: NSButton) {
        openFilePKC(inputField: &inputField, outputField: &outputField, sender: sender)
    }
    
    @IBAction func safeFile(_ sender: NSButton) {
        saveFilePKC(sender: sender)
    }
    
}
