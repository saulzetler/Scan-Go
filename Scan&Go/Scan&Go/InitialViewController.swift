//
//  InitialViewController.swift
//  Scan&Go
//
//  Created by Saul Zetler on 2016-10-21.
//  Copyright © 2016 McGill HCI. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class InitialViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let screenSize = UIScreen.main.bounds
    var imgView: UIImageView!
    
    var textView: UITextView!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButtons() {
        let buttonFrame = CGRect(x: screenSize.width*0.2, y: screenSize.height*0.4, width: screenSize.width*0.6, height: screenSize.height*0.2)
        let takePhotoButton = makeTextButton(text: "Take Photo", frame: buttonFrame, target: #selector(InitialViewController.openCameraButton(_:)), circle: false, textColor: UIColor.white, tinted: true, backgroundColor: UIColorFromHex(rgbValue: 0x8e44ad), textSize: 32)
        takePhotoButton.layer.cornerRadius = 10
        takePhotoButton.layer.masksToBounds = true
        self.view.addSubview(takePhotoButton)
    }
    
    func openCameraButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.dismiss(animated: true, completion: {
            self.textToSpeech(message: "Right now you would be hearing the words that were recognized by the Optical Character Recognition software. To take another photo, double tap anywhere.")
        });
    }
    
    
    func textToSpeech(message: String)
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            // Put your code which should be executed with a delay here
            self.myUtterance = AVSpeechUtterance(string: message)
            self.myUtterance.rate = 0.5
            self.synth.speak(self.myUtterance)
            
        })
        
    }
    
    
}
