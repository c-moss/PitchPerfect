//
//  BaseViewController.swift
//  Pitch Perfect
//
//  Created by Campbell Moss on 29/11/15.
//  Copyright © 2015 Campbell Moss. All rights reserved.
//

import UIKit
import Foundation
/**
 Base class for view controllers. Contains utility functions.
*/
class BaseViewController: UIViewController {
    
    /**
     Show a simple pop-up alert dialog.
     - parameter title: String to show in the dialog title
     - parameter message: String to show in the body of the dialog
     - parameter handler: Optional handler block for when the dialog is dismissed
    */
    func showAlert(title: String, message: String, handler: (() -> Void)?=nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var alertAction:UIAlertAction
        if let uHandler = handler {
            alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in
                uHandler()
            })
        } else {
            alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        }
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}