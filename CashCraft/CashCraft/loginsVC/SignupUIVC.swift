//
//  SignupUIVC.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/20/23.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFAudio

class SignupUIVC: UIViewController {
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var gmailLBL: UITextField!
    
    @IBOutlet weak var passwordLBL: UITextField!
    
    @IBOutlet weak var confirmpasswordLBL: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let path = Bundle.main.path(forResource: "Error", ofType: "mp3") else {
                    print("Sound file not found")
                    return
                }

                let url = URL(fileURLWithPath: path)

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                } catch {
                    print("Error loading sound file: \(error.localizedDescription)")
                }
    }
    
    @IBAction func Signin(_ sender: UIButton) {
        
        guard let email = gmailLBL.text ,!email.isEmpty else {
            let alertmsg = UIAlertController(title: "Sign in", message: "Enter a valid email", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style: .destructive,handler: { action in
                self.audioPlayer?.play()
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        guard let password = passwordLBL.text,!password.isEmpty else {
            let alertmsg = UIAlertController(title: "Sign in", message: "Enter a password ", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style: .destructive,handler: { action in
                self.audioPlayer?.play()
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return}
        guard let confirmpassword = confirmpasswordLBL.text, password == confirmpassword else {
            let alertmsg = UIAlertController(title: "Sign in", message: "password mismatch", preferredStyle: .alert)
            alertmsg.addAction(UIAlertAction(title: "OK" , style: .destructive,handler: { action in
                self.audioPlayer?.play()
            }))
            self.present(alertmsg, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult , error in
            if let e = error{
                print("error",e)
                let alertmsg = UIAlertController(title: "Sign in", message: "You already have account", preferredStyle: .alert)
                alertmsg.addAction(UIAlertAction(title: "OK" , style: .destructive ,handler: { action in
                    self.audioPlayer?.play()
                    self.gmailLBL.text = ""
                    self.passwordLBL.text = ""
                    self.confirmpasswordLBL.text = ""
                }))
                self.present(alertmsg, animated: true, completion: nil)
            }
            else{
                let alertmsg = UIAlertController(title: "Sign in", message: "Account has been created", preferredStyle: .alert)
                alertmsg.addAction(UIAlertAction(title: "OK" , style:.default ,handler: { action in
                    self.performSegue(withIdentifier: "signloginsegue", sender: self)
                }))
                self.present(alertmsg, animated: true, completion: nil)
            }
        }
    }
    
}
