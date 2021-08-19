//
//  SignUpViewController.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/06/24.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var passwordTextField:UITextField!
    @IBOutlet var confirmTextField:UITextField!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
       userIdTextField.delegate = self
       emailTextField.delegate = self
       passwordTextField.delegate = self
       confirmTextField.delegate = self
       
    }
       //TextFieldを閉じるコード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
      }
      
      
      //SignUpのコード
     @IBAction func signUp(){
          let user = NCMBUser()
          if userIdTextField.text!.count <= 4 {
          print("文字数が足りません")
          return
       }
         user.userName = userIdTextField.text!
         user.mailAddress = emailTextField.text!
           //もし一致していたら代入
         if passwordTextField.text == confirmTextField.text {
         user.password = passwordTextField.text!
           
       } else {
          print("パスワードの不一致")
       }
        
       user.signUpInBackground { (error) in
          if error != nil{
           //エラーがあった場合
           print(error)
           
       } else {
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
            //画面の一番下を取得
           UIApplication.shared.keyWindow?.rootViewController = rootViewController
           //ログイン状態の保持
           let ud = UserDefaults.standard
               ud.set(true, forKey: "isLogin")
               ud.synchronize()
       }
          }
}
}
