//
//  MailadressViewController.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/06/24.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit
import NCMB


class MailAdressViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
    }
    @IBAction func signUp() {
        let user = NCMBUser()
        user.mailAddress = emailTextField.text!
        // メール認証
        var error : NSError? = nil
        NCMBUser.requestAuthenticationMail(emailTextField.text!, error: &error)
        
        if (error != nil) {
            print(error ?? "")
        }
        print("メール完了")
        //present modal
        self.dismiss(animated: true, completion: nil)
        //show+navigatoncontroller
        self.navigationController?.popViewController(animated: true)
        print("dismiss完了")
        
        print(emailTextField.text!)
    }
    
}
