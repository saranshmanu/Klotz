//
//  ProfileViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 09/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var editButtonViewRight: UIView!
    @IBOutlet weak var editButtonViewLeft: UIView!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var identityTextField: UILabel!
    @IBOutlet weak var balanceTextField: UILabel!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        balanceTextField.text = String(balance) + " INR"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().reference().child("users/" + id + "/finance").observe(.childChanged, with: {_ in
            print("value changed")
            FIRDatabase.database().reference().child("users/" + id + "/finance").observeSingleEvent(of: .value , with: { (snapshot) in if let value = snapshot.value as? NSDictionary{
                    balance = String(describing: value["balance"]!)
                    self.balanceTextField.text = balance + " INR"
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        
        //to update all the profile details from the constant
        identityTextField.text = id
        balanceTextField.text = String(balance) + " INR"
        nameTextField.text = name
        emailTextField.text = email
        
        // Do any additional setup after loading the view.
        cardView.layer.cornerRadius = 10.0
        topCardView.roundCorners([.topRight,.topLeft], 9.0)
        editButtonView.layer.cornerRadius = 10.0
        editButtonViewLeft.roundCorners([.topLeft,.bottomLeft], 9.0)
        editButtonViewRight.roundCorners([.topRight,.bottomRight], 9.0)
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
