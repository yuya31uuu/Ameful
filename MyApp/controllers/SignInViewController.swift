//
//  SignInViewController.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/06/24.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit
import NCMB

class SignInViewController: UIViewController,UITextFieldDelegate {

   @IBOutlet var userIdTextField:UITextField!
   @IBOutlet var passwordTextField:UITextField!
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        passwordTextField.delegate = self
       
    }
        //キーボード閉じるコード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func signIn(){
        if userIdTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
        NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
        if error != nil {
            print("error")
        } else {
            //ログイン成功
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
           //ログイン状態の保持の３行のコード
        let ud = UserDefaults.standard
        ud.set(true, forKey: "isLogin")
        ud.synchronize()
          
            
            
            
            }
            }
      
        }
    }
    
    @IBAction func forgetPassword(){
    
    
}
}
