//
//  ViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 09/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLayoutSubviews() {
        createGradientLayer()
    }
    func createGradientLayer(){
        var gradientLayerLoginView: CAGradientLayer!
        gradientLayerLoginView = CAGradientLayer()
        gradientLayerLoginView.frame = self.loginView.bounds
        gradientLayerLoginView.colors = [UIColor.init(red: 79/255, green: 78/255, blue: 78/255, alpha: 1.0).cgColor, UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor]
        gradientLayerLoginView.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayerLoginView.endPoint = CGPoint(x: 0.0, y: 1.0)
        loginView.layer.insertSublayer(gradientLayerLoginView, at: 0)
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.dropShadow()
        
        var gradientLayerSignUpView: CAGradientLayer!
        gradientLayerSignUpView = CAGradientLayer()
        gradientLayerSignUpView.frame = self.signUpView.bounds
        gradientLayerSignUpView.colors = [UIColor.init(red: 18/255, green: 26/255, blue: 48/255, alpha: 1.0).cgColor, UIColor.init(red: 13/255, green: 11/255, blue: 27/255, alpha: 1.0).cgColor]
        gradientLayerSignUpView.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayerSignUpView.endPoint = CGPoint(x: 0.0, y: 1.0)
        signUpView.layer.insertSublayer(gradientLayerSignUpView, at: 0)
        signUpView.layer.shadowColor = UIColor.black.cgColor
        signUpView.dropShadow()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginView.layer.cornerRadius = 10.0
        signUpView.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -3, height: 3)
        self.layer.shadowRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
