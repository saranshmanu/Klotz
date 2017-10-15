//
//  SignUpViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 09/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 10.0
        logoView.roundCorners([.topRight,.topLeft], 9.0)
        
        usernameTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
        
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard)))
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = UIColor.white
        var gradientLayerSignUpView: CAGradientLayer!
        gradientLayerSignUpView = CAGradientLayer()
        gradientLayerSignUpView.frame = self.signUpView.bounds
        gradientLayerSignUpView.colors = [UIColor.init(red: 18/255, green: 26/255, blue: 48/255, alpha: 1.0).cgColor, UIColor.init(red: 13/255, green: 11/255, blue: 27/255, alpha: 1.0).cgColor]
        gradientLayerSignUpView.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayerSignUpView.endPoint = CGPoint(x: 0.0, y: 1.0)
        signUpView.layer.insertSublayer(gradientLayerSignUpView, at: 0)
        signUpView.layer.shadowColor = UIColor.black.cgColor
        signUpView.dropShadow()
        
        var gradientLayerLogoView: CAGradientLayer!
        gradientLayerLogoView = CAGradientLayer()
        gradientLayerLogoView.frame = self.logoView.bounds
        gradientLayerLogoView.colors = [UIColor.init(red: 22/255, green: 22/255, blue: 22/255, alpha: 1.0).cgColor, UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor]
        gradientLayerLogoView.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayerLogoView.endPoint = CGPoint(x: 0.0, y: 1.0)
        logoView.layer.insertSublayer(gradientLayerLogoView, at: 0)
        logoView.layer.shadowColor = UIColor.black.cgColor
        logoView.dropShadow()

    }
    // for tapping
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        fullNameTextField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                print("You have successfully signed up")
                FIRDatabase.database().reference().child("users").child((user?.uid)! + "/profile").setValue(["email" : self.usernameTextField.text!,"name" : self.fullNameTextField.text!,"totalAmountReceived" : "0","totalAmountSent" : "0"])
                FIRDatabase.database().reference().child("users").child((user?.uid)! + "/finance").setValue(["balance" : "20000"])
                balance = String(20000)
                name = self.fullNameTextField.text!
                id = (FIRAuth.auth()?.currentUser?.uid)!
                totalAmountReceived = "0"
                totalAmountSent = "0"
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(vc!, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
extension UIView {
    func roundCorners(_ corner: UIRectCorner,_ radii: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii)).cgPath
        
        self.layer.mask = maskLayer
        layer.masksToBounds = true
    }
}
