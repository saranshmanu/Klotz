//
//  LoginViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 09/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBAction func loginAction(_ sender: Any) {
        login()
    }
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var fieldBackgroundView: UIView!
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    func login(){
        self.view.layoutIfNeeded()
        loginButton.isEnabled = false
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil{
                //self.activityIndicator.isHidden = true
                self.loginButton.isEnabled = true
                self.usernameTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                print("Login Successfull")
                id = (FIRAuth.auth()?.currentUser?.uid)!
                FIRDatabase.database().reference().child("users/" + id + "/profile").observeSingleEvent(of: .value , with: { (snapshot) in
                    // Get user value
                    if let value = snapshot.value as? NSDictionary{
                        name = String(describing: value["name"]!)
                        email = String(describing: value["email"]!)
                        FIRDatabase.database().reference().child("users/" + id + "/finance").observeSingleEvent(of: .value , with: { (snapshot) in
                            // Get user value
                            if let value = snapshot.value as? NSDictionary{
                                balance = String(describing: value["balance"]!)
                                //Go to the HomeViewController if the login is sucessful
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                                self.present(vc!, animated: true, completion: nil)
                            }
                            // ...
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            else{
                //self.activityIndicator.isHidden = true
                self.loginButton.isEnabled = true
                self.usernameTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                print("Login Unsuccessfull")
                //to initiate alert if login is unsuccesfull
                let alertController = UIAlertController(title: "Try Again", message: "Incorrect username or password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        // Do any additional setup after loading the view.
        var gradientLayerLoginView: CAGradientLayer!
        gradientLayerLoginView = CAGradientLayer()
        gradientLayerLoginView.frame = self.loginButtonView.bounds
        gradientLayerLoginView.colors = [UIColor.init(red: 79/255, green: 78/255, blue: 78/255, alpha: 1.0).cgColor, UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor]
        gradientLayerLoginView.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayerLoginView.endPoint = CGPoint(x: 0.0, y: 1.0)
        loginButtonView.layer.insertSublayer(gradientLayerLoginView, at: 0)
        loginButtonView.layer.shadowColor = UIColor.black.cgColor
        loginButtonView.dropShadow()
        fieldBackgroundView.layer.cornerRadius = 10.0
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    // for tapping
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
