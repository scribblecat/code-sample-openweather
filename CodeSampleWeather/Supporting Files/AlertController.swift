//
//  AlertController.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/12/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

//  Note: This alert controller can be created from any object
//  because it creates its own window and propels it to the front of the screen.

//  This class was ported from / based on:
//  https://github.com/kirbyt/WPSKit/blob/master/WPSKit/UIKit/WPSAlertController.m
//
//  WPSAlertController.h
//
//  Created by Kirby Turner.
//  Copyright 2015 White Peak Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import UIKit
import ObjectiveC

// TODO: Remove if not going to use this. Was handy when debugging.
class AlertController : UIAlertController {
    
    private var alertWindow : UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
    func show() {
        showAnimated(true)
    }
    
    func showAnimated(_ animated: Bool) {
        let blankVC = UIViewController.init()
        blankVC.view.backgroundColor = .clear
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = blankVC
        window.backgroundColor = .clear
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        
        alertWindow = window
        blankVC.present(self, animated: animated, completion: nil)
    }
    
    @objc class func presentOkAlert(title : String?,
                                    message: String?) {
        let alert = AlertController.init(title: title,
                                         message: message,
                                         preferredStyle: .alert)
        let okTitle = NSLocalizedString("OK",
                                        comment: "OK")
        let okAction = UIAlertAction.init(title: okTitle,
                                          style: .default)
        alert.addAction(okAction)
        alert.show()
    }
}
