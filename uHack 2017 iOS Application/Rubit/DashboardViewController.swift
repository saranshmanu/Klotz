//
//  DashboardViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 09/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {

    @IBOutlet weak var newTransactionButtonViewRight: UIView!
    @IBOutlet weak var newTransactionButtonViewLeft: UIView!
    @IBOutlet weak var fundTransferButtonViewRight: UIView!
    @IBOutlet weak var fundTransferButtonViewLeft: UIView!
    @IBOutlet weak var cardViewLayerTwo: UIView!
    @IBOutlet weak var fundTransferButtonView: UIView!
    @IBOutlet weak var newTransactionButtonView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var qrCode: UIImageView!
    
    @IBOutlet weak var idNumber: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var totalSent: UILabel!
    @IBOutlet weak var totalReceived: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()//(FIRAuth.auth()?.currentUser?.uid)!
        FIRDatabase.database().reference().child("users/" + id + "/finance").observe(.childChanged, with: {_ in
            FIRDatabase.database().reference().child("users/" + id + "/finance").observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary{
                    balance = String(describing: value["balance"]!)
                    self.balanceLabel.text = balance + " INR"
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        
        idNumber.text = id
        nameLabel.text = name
        balanceLabel.text = String(balance) + " INR"
        totalSent.text = totalAmountSent
        totalReceived.text = totalAmountReceived
        
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        // Override point for customization after application launch.
        // Do any additional setup after loading the view.
        cardView.layer.cornerRadius = 10.0
        cardViewLayerTwo.layer.cornerRadius = 10.0
        fundTransferButtonView.layer.cornerRadius = 10.0
        fundTransferButtonViewLeft.roundCorners([.topLeft,.bottomLeft], 9.0)
        fundTransferButtonViewRight.roundCorners([.topRight,.bottomRight], 9.0)
        newTransactionButtonView.layer.cornerRadius = 10.0
        newTransactionButtonViewLeft.roundCorners([.topLeft,.bottomLeft], 9.0)
        newTransactionButtonViewRight.roundCorners([.topRight,.bottomRight], 9.0)
        
        // For generating qr code
        var code = id//FIRAuth.auth()?.currentUser?.uid
        if self.qrcodeImage == nil {
            if code == "" {
                print("no qr code available")
                return
            }
            let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            self.qrcodeImage = filter?.outputImage
            self.displayQRCodeImage()
            qrCode.contentMode = .scaleAspectFit
        }
        self.qrCode.alpha = 0.9
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        balanceLabel.text = String(balance) + " INR"
    }
    var qrcodeImage: CIImage!
    // function to clear out the blur QR code
    func displayQRCodeImage() {
        let scaleX = qrCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrCode.image = UIImage(ciImage: transformedImage)
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
