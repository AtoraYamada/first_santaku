//
//  UserEditViewController.swift
//  first_santaku
//
//  Created by 山田 亜虎 on 2019/06/11.
//  Copyright © 2019 山田 亜虎. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class UserEditViewController: UIViewController, UITextFieldDelegate {
    var keyboard2 : AVAudioPlayer! = nil
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var signUp: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var inputNickname: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
            if let user = user {
                inputNickname.text = user.displayName
                inputEmail.text = user.email
        }
        let keyboard2Path = Bundle.main.path(forResource: "keyboard2", ofType: "mp3")!
        let k2:URL = URL(fileURLWithPath: keyboard2Path)
        do {
            keyboard2 = try AVAudioPlayer(contentsOf: k2, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        keyboard2.prepareToPlay()
        attributed()
        inputNickname.delegate = self
        inputEmail.delegate = self
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
        let text1 = NSAttributedString(string: "EDIT USER", attributes: textAttributes)
        let text2 = NSAttributedString(string: "E-MAIL", attributes: textAttributes)
        let text4 = NSAttributedString(string: "NICKNAME", attributes: textAttributes)
        nickname.attributedText = text4
        signUp.attributedText = text1
        email.attributedText = text2
    }
    
    @IBAction func getNickname(_ sender: Any) {
    }
    @IBAction func getEmail(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputNickname.resignFirstResponder()
        inputEmail.resignFirstResponder()
    }
    
    func buttonatrributed(){
        signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signUpButton.setTitle("DONE", for: .normal)
    }
    
    @IBAction func DoneButton(_ sender: Any) {
        done()
        keyboard2.currentTime = 0
        keyboard2.play()
    }
    
    func done() {

        guard let nickname = inputNickname.text else { return }
        guard let email = inputEmail.text else  { return }
        let user = Auth.auth().currentUser
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nickname
        changeRequest?.commitChanges { error in
                    if let error = error {
                        print(error)
                        print("登録できませんでした")
                        let alert = UIAlertController(title: "Failed to Sign Up", message: "check your nickname, email or password", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                    }
        }
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                if let error = error {
                    print(error)
                    print("登録できませんでした")
                    let alert = UIAlertController(title: "Failed to Sign Up", message: "check your nickname, email or password", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
        }
        let db = Firestore.firestore()
        db.collection("users").document(user!.uid).setData([
                    "username": nickname
                    ])
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
        self.present(storyboard, animated: true, completion: nil)
    }
    
}

