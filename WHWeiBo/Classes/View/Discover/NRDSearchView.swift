//
//  NRDSearchView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/14.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDSearchView: UIView, UITextFieldDelegate {
    
   

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var textFieldTrailing: NSLayoutConstraint!
   
    
    
    //  通过类方法加载search视图
    class func searchView() -> NRDSearchView {
        
        return UINib(nibName: "NRDSearchView", bundle: nil).instantiateWithOwner(nil, options: nil).last! as! NRDSearchView
    }

    override func awakeFromNib() {
        searchTextField.delegate = self
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
//        self.endEditing(true)
        searchTextField.resignFirstResponder()
        self.textFieldTrailing.constant = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func searchAction(sender: AnyObject) {
            textFieldTrailing.constant = 45
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.layoutIfNeeded()
                }, completion: nil)
    
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldTrailing.constant = cancelButton.width
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
}
