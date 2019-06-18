//
//  SignInViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/08.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signIn: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        attributed()
        inputEmail.delegate = self
        inputPassword.delegate = self
        buttonatrributed()
    }
    
    func attributed() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .strokeColor : UIColor.green,
            .strokeWidth : -3.0
        ]
        let text1 = NSAttributedString(string: "SIGN IN", attributes: textAttributes)
        let text2 = NSAttributedString(string: "E-MAIL", attributes: textAttributes)
        let text3 = NSAttributedString(string: "PASSWORD", attributes: textAttributes)
        signIn.attributedText = text1
        email.attributedText = text2
        password.attributedText = text3
    }

    @IBAction func getEmail(_ sender: Any) {
    }
    @IBAction func getPassword(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputEmail.resignFirstResponder()
        inputPassword.resignFirstResponder()
    }
    
    func buttonatrributed(){
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.setTitle("SIGN IN", for: .normal)
        signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signUpButton.setTitle("SIGN UP", for: .normal)
    }
    @IBAction func signInButton(_ sender: Any) {
        signin()
    }
    
    func signin() {
        
        guard let email = inputEmail.text else  { return }
        guard let password = inputPassword.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil{
                print("ログインできました")
                self.performSegue(withIdentifier: "signInToMain", sender: self)
            }
            else {
                print("ログインできませんでした")
                let alert = UIAlertController(title: "Failed to Login", message: "check your email or password", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
