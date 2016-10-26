//
//  ViewController.swift
//  Scan&Go
//
//  Created by Saul Zetler on 2016-10-19.
//  Copyright © 2016 McGill HCI. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeTextButton(text: String, frame: CGRect, target: Selector, circle: Bool = false, textColor: UIColor = UIColor.black, tinted: Bool = true, backgroundColor: UIColor = UIColor.clear, textSize: CGFloat = 12) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: target, for: .touchUpInside)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: textSize)
        button.setTitleColor(textColor, for: UIControlState.normal)
        if tinted == true {
            button.setTitleColor(UIColorFromHex(rgbValue: 0x3498db, alpha: 1), for: UIControlState.selected)
        }
        if circle == true {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
        button.backgroundColor = backgroundColor
        return button
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

