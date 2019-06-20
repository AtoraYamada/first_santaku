//
//  SignInViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/08.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class SignInViewController: UIViewController, UITextFieldDelegate {
    var keyboard2 : AVAudioPlayer! = nil
    var keyboard1 : AVAudioPlayer! = nil

    @IBOutlet weak var signIn: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboard2Path = Bundle.main.path(forResource: "keyboard2", ofType: "mp3")!
        let k2:URL = URL(fileURLWithPath: keyboard2Path)
        do {
            keyboard2 = try AVAudioPlayer(contentsOf: k2, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        let keyboard1Path = Bundle.main.path(forResource: "keyboard1", ofType: "mp3")!
        let k1:URL = URL(fileURLWithPath: keyboard1Path)
        do {
            keyboard1 = try AVAudioPlayer(contentsOf: k1, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        keyboard2.prepareToPlay()
        keyboard1.prepareToPlay()
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
        keyboard2.currentTime = 0
        keyboard2.play()
    }
    
    @IBAction func moveToSignUp(_ sender: Any) {
        keyboard1.currentTime = 0
        keyboard1.play()
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
