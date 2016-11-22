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
import TesseractOCR

class InitialViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, G8TesseractDelegate {
    
    let screenSize = UIScreen.main.bounds
    var imgView: UIImageView!
    
    var textView: UITextView!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        startTutorial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tesseractOCR(image: UIImage) -> String {
        let tesseract:G8Tesseract = G8Tesseract(language:"eng")
        //tesseract.language = "eng+ita"
        tesseract.delegate = self
        tesseract.maximumRecognitionTime = 60
        tesseract.charWhitelist = "01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        NSLog("%@", tesseract.recognizedText)
        return tesseract.recognizedText
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return true; // return true if you need to interrupt tesseract before it finishes
    }
    
    func startTutorial() {
        if UIAccessibilityIsVoiceOverRunning() {
            textToSpeech(message: "Welcome to Scan and Go! You can skip this tutorial by double tapping anywhere on the screen. This application will help you identify items in a grocery store, assuming you have access to the label underneath the item you are examining. We will provide instructions for you to get the whole way through the application. Double tapping the screen will interrupt the tutorial, so do not follow the instructions right away. Allow the tutorial to complete, and then you can go about using the application. If at any point you get confused, you can tap once to get context on where you are and what you can do. The first thing you need to do is double tap the screen to enter camera mode. At this point you should locate the label on the shelf under the item you are looking for, and take a picture of it. As a result of Apple’s restrictions on the camera interface you will need to confirm your picture. Once this is done, and you have confirmed your picture, our application will make a best effort attempt at reading out what it sees. You can interrupt the speech at any point by tapping the screen twice, which will take you back to the picture taking screen.")
        } else {
            textToSpeech(message: "Welcome to Scan and Go! You can skip this tutorial by tapping the button on the screen. This application will help you identify items in a grocery store, assuming you have access to the label underneath the item you are examining. We will provide instructions for you to get the whole way through the application. Tapping the screen will interrupt the tutorial, so do not follow the instructions right away. Allow the tutorial to complete, and then you can go about using the application. The first thing you need to do is tap the screen to enter camera mode. At this point you should locate the label on the shelf under the item you are looking for, and take a picture of it. As a result of Apple’s restrictions on the camera interface you will need to confirm your picture. Once this is done, and you have confirmed your picture, our application will make a best effort attempt at reading out what it sees. You can interrupt the speech at any point by tapping the button, which will take you back to the picture taking screen.")
        }
    }
    
    func addButtons() {
        let buttonFrame = CGRect(x: screenSize.width*0.2, y: screenSize.height*0.4, width: screenSize.width*0.6, height: screenSize.height*0.2)
        let takePhotoButton = makeTextButton(text: "Take Photo", frame: buttonFrame, target: #selector(InitialViewController.openCameraButton(_:)), circle: false, textColor: UIColor.white, tinted: true, backgroundColor: UIColorFromHex(rgbValue: 0x8e44ad), textSize: 32)
        takePhotoButton.layer.cornerRadius = 10
        takePhotoButton.layer.masksToBounds = true
        self.view.addSubview(takePhotoButton)
    }
    
    func openCameraButton(_ sender: AnyObject) {
        if synth.isSpeaking {
           synth.stopSpeaking(at: .immediate)
        }
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
            //self.textToSpeech(message: "Right now you would be hearing the words that were recognized by the Optical Character Recognition software. To take another photo, double tap anywhere.")
            self.textToSpeech(message: self.tesseractOCR(image: image))
        });
    }
    
    
    func textToSpeech(message: String)
    {
        myUtterance = AVSpeechUtterance(string: message)
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            // Put your code which should be executed with a delay here
            
        })
        */
    }
    
    
}
