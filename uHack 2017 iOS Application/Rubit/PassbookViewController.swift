//
//  PassbookViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 09/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class PassbookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timeDelay = 0.3
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    @IBOutlet weak var tapCard: UIView!
    @IBOutlet weak var tapCardTopView: UIView!
    @IBOutlet weak var tapCardView: UIView!
    
    @IBOutlet weak var topCardView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = passbookTableView.dequeueReusableCell(withIdentifier: "passbook", for: indexPath as IndexPath) as! PassbookTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passbookTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        UIView.animate(withDuration: timeDelay, animations: {
            self.view.layoutIfNeeded()
            self.tapCard.alpha = 1.0
            self.tapCard.isHidden = false
        })
    }
    
    func dismissCard(){
        UIView.animate(withDuration: timeDelay, animations: {
            self.tapCard.alpha = 0.0
            self.tapCard.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    
    @IBOutlet weak var passbookTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PassbookViewController.dismissCard)))
        
        tapCard.isHidden = true
        tapCard.alpha = 0.0
        
        // Do any additional setup after loading the view.
        passbookTableView.delegate = self
        passbookTableView.dataSource = self
        cardView.layer.cornerRadius = 10.0
        topCardView.roundCorners([.topRight,.topLeft], 10.0)
        passbookTableView.roundCorners([.bottomRight,.bottomLeft], 10.0)
        
        //for UI of tap card
        tapCardView.layer.cornerRadius = 10.0
        tapCardTopView.roundCorners([.topRight,.topLeft], 10.0)
        
        goBackButton.layer.cornerRadius = 12.0
        goBackButton.layer.borderWidth = 1.0
        goBackButton.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        
        reportProblemButton.layer.cornerRadius = 12.0
        reportProblemButton.layer.borderWidth = 1.0
        reportProblemButton.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
    }
    
    @IBAction func viewButtonAction(_ sender: Any) {
        UIView.animate(withDuration: timeDelay, animations: {
            self.view.layoutIfNeeded()
            self.tapCard.alpha = 1.0
            self.tapCard.isHidden = false
        })
    }
    @IBAction func goBackAction(_ sender: Any) {
        UIView.animate(withDuration: timeDelay, animations: {
            self.tapCard.alpha = 0.0
            self.tapCard.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var reportProblemButton: UIButton!
    
    
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
