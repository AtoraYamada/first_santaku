//
//  SignUpViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/08.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var signUp: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var inputNickname: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        attributed()
        inputNickname.delegate = self
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
        let text1 = NSAttributedString(string: "SIGN UP", attributes: textAttributes)
        let text2 = NSAttributedString(string: "E-MAIL", attributes: textAttributes)
        let text3 = NSAttributedString(string: "PASSWORD", attributes: textAttributes)
        let text4 = NSAttributedString(string: "NICKNAME", attributes: textAttributes)
        nickname.attributedText = text4
        signUp.attributedText = text1
        email.attributedText = text2
        password.attributedText = text3
    }
    
    @IBAction func getNickname(_ sender: Any) {
    }
    @IBAction func getEmail(_ sender: Any) {
    }
    @IBAction func getPassword(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputNickname.resignFirstResponder()
        inputEmail.resignFirstResponder()
        inputPassword.resignFirstResponder()
    }
    
    func buttonatrributed(){
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.setTitle("SIGN IN", for: .normal)
        signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signUpButton.setTitle("SIGN UP", for: .normal)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        signup()
    }
    func signup() {
        
        guard let nickname = inputNickname.text else { return }
        guard let email = inputEmail.text else  { return }
        guard let password = inputPassword.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error == nil{
                print("登録完了")
                let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = nickname
                        changeRequest.commitChanges { error in
                            if let error = error {
                                print(error)
                                return
                            }
                        }
                    }
                let db = Firestore.firestore()
                db.collection("users").document(user!.uid).setData([
                    "username": nickname
                ])
            }
            else {
                print("登録できませんでした")
                let alert = UIAlertController(title: "Failed to Sign Up", message: "check your nickname, email or password", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
