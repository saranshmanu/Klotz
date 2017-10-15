//
//  PaymentViewController.swift
//  Rubit
//
//  Created by Saransh Mittal on 10/09/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import LocalAuthentication
import AVFoundation
import WVCheckMark
import Firebase



var amountTransferredForSuccessfullTransaction = 0

class PaymentViewController: UIViewController, QRCodeReaderViewControllerDelegate  {
    
    override func viewDidAppear(_ animated: Bool) {
        balanceLabel.text = String(balance) + " INR"
    }
    
    @IBOutlet weak var accountHoldersIDLabel: UILabel!
    @IBOutlet weak var amountToBeTransferredLabel: UILabel!
    @IBOutlet weak var receiversLabel: UILabel!
    @IBOutlet weak var accountHoldersLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var receiversAddress: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    
    @IBOutlet weak var giverField: UILabel!
    @IBOutlet weak var paymentCard: UIView!
    @IBOutlet weak var makePaymentButton: UIView!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var checkMark: WVCheckMark!
    @IBOutlet weak var paymentStatus: UILabel!
    
    var qrcodeImage: CIImage!
    
    func setupViewsForRippleEffect(){
        viewSample.layer.zPosition = 1111
        self.viewSample.layer.cornerRadius = self.viewSample.frame.size.width / 2;
        self.viewSample.clipsToBounds = true
        self.viewSample.backgroundColor = UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.5)
        animateRippleEffect()
    }
    
    func animateRippleEffect(){
        self.viewSample.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, animations: {
            self.viewSample.alpha = 1.0
        })
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0,options: UIViewAnimationOptions.curveLinear,animations: {
            self.viewSample.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.viewSample.layer.cornerRadius = self.viewSample.frame.height/2
            self.viewSample.alpha = 0.0
        }, completion: {finished in
            self.animateRippleEffect()
        })
    }
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    func paymentSuccess() {
        var receiverBalance = 0
        var hash = randomString(length: 10)
            FIRDatabase.database().reference().child("users/" + String(describing: receiversAddress.text!) + "/finance").observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? NSDictionary{
                    receiverBalance = Int(String(describing: value["balance"]!))!
                    print(receiverBalance)
                    FIRDatabase.database().reference().child("users").child(String(describing: self.receiversAddress.text!) + "/finance").setValue(["balance" : String(receiverBalance + amountTransferredForSuccessfullTransaction)])
                    balance = String(Int(balance)! - amountTransferredForSuccessfullTransaction)
                    FIRDatabase.database().reference().child("users").child(id + "/finance").setValue(["balance" : balance])
                    
                    //to get the current date and time
                    let date = Date()
                    let calendar = Calendar.current
                    let currentDate:String = String(calendar.component(.day, from: date)) + "/" + String(calendar.component(.month, from: date)) + "/" + String(calendar.component(.year, from: date))
                    let currentTime:String = String(calendar.component(.hour, from: date)) + ":" + String(calendar.component(.minute, from: date)) + ":" + String(calendar.component(.second, from: date))
                    FIRDatabase.database().reference().child("live/").child(hash).setValue(["from" : id, "to" : self.receiversAddress.text, "amount" : amountTransferredForSuccessfullTransaction, "date" : currentDate, "time" : currentTime])
                    FIRDatabase.database().reference().queryOrderedByKey()
//                    
//                    FIRDatabase.database().reference().child("users").child(id + "/transactions/" + ).setValue(["from" : id, "to" : self.receiversAddress.text, "amount" : amountTransferredForSuccessfullTransaction, "date" : currentDate, "time" : currentTime])
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        balanceLabel.text = String(balance) + " INR"
        receiversLabel.text = "nil"
        amountToBeTransferredLabel.text = "nil"
        paymentStatus.isHidden = false
        checkMark.isHidden = false
        paymentStatus.text = "SUCCESS"
        logoImage.isHidden = true
        viewSample.isHidden = true
        mapImageView.isHidden = true
        checkMark.setColor(color: UIColor.init(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0).cgColor)
        checkMark.setDuration(speed: 1.5)
        checkMark.start()
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            UIView.animate(withDuration: 0.4, animations: {
                self.loader.alpha = 0.0
                self.view.layoutIfNeeded()
            },completion:{
                (finished:Bool) in self.setTabBarVisible(visible: true, animated: true)
            })
        }
        self.setTabBarVisible(visible: true, animated: true)
    }
    
    func paymentFailure(){
        paymentStatus.isHidden = false
        checkMark.isHidden = false
        paymentStatus.text = "FAILURE"
        logoImage.isHidden = true
        viewSample.isHidden = true
        mapImageView.isHidden = true
        checkMark.setColor(color: UIColor.init(red: 174/255, green: 34/255, blue: 34/255, alpha: 1.0).cgColor)
        checkMark.setDuration(speed: 1.5)
        checkMark.startX()
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            UIView.animate(withDuration: 0.4, animations: {
                self.loader.alpha = 0.0
                self.view.layoutIfNeeded()
            },completion:{
                (finished:Bool) in self.setTabBarVisible(visible: true, animated: true)
            })
        }
    }
    @IBAction func transactionAction(_ sender: Any) {
        fingerprintAuthentication()
    }
    @IBAction func scanAction(_ sender: Any) {
        scan()
    }
    @IBAction func addAmountToBePaid(_ sender: Any) {
       let alertController = UIAlertController(title : "Welcome!", message: "Please enter following details!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let amount = alertController.textFields![0] as UITextField
            let name = alertController.textFields![1] as UITextField
            amountTransferredForSuccessfullTransaction = Int(amount.text!)!
            self.amountToBeTransferredLabel.text = amount.text
            self.receiversLabel.text = name.text
        }))
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "amount"
            textField.textAlignment = .center
        })
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Receiver's name"
            textField.textAlignment = .center
        })
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        giverField.text = name
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
        
        accountHoldersLabel.text = name
        balanceLabel.text = String(balance) + " INR"
        accountHoldersIDLabel.text = id
        loader.isHidden = true
        loader.alpha = 0.0
        receiversAddress.text = "nil"
        receiversLabel.text = "nil"
        amountToBeTransferredLabel.text = "nil"
        // Do any additional setup after loading the view.
        var gradientLayerLoginView: CAGradientLayer!
        gradientLayerLoginView = CAGradientLayer()
        gradientLayerLoginView.frame = self.makePaymentButton.bounds
        gradientLayerLoginView.colors = [UIColor.init(red: 79/255, green: 78/255, blue: 78/255, alpha: 1.0).cgColor, UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor]
        gradientLayerLoginView.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayerLoginView.endPoint = CGPoint(x: 0.0, y: 1.0)
        makePaymentButton.layer.insertSublayer(gradientLayerLoginView, at: 0)
        paymentCard.layer.cornerRadius = 10.0
        scanButton.layer.cornerRadius = 12.0
        scanButton.layer.borderWidth = 1.0
        scanButton.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        amountButton.layer.cornerRadius = 12.0
        amountButton.layer.borderWidth = 1.0
        amountButton.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        
        // For generating qr code
        var code = id
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
//            qrCode.contentMode = .scaleAspectFit
        }        
    }
    //for activation of finger print authentication this function is used along with notify function
    func fingerprintAuthentication(){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,error: &error){
            // Device can use TouchID
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,localizedReason: "Access requires authentication",reply: {(success, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        switch error!._code {
                        case LAError.Code.systemCancel.rawValue:self.notifyUser("Session cancelled",err: error?.localizedDescription)
                        case LAError.Code.userCancel.rawValue:self.notifyUser("Please try again",err: error?.localizedDescription)
                        case LAError.Code.userFallback.rawValue:self.notifyUser("Authentication",err: "Success")
                        // Custom code to obtain password here
                        default:self.notifyUser("Authentication failed",err: error?.localizedDescription)
                        }
                    }
                    else {
                        //If Authentication is successfull then payment is carried forward
                        self.viewSample.reloadInputViews()
                        self.logoImage.isHidden = false
                        self.viewSample.isHidden = false
                        self.mapImageView.isHidden = false
                        self.paymentStatus.isHidden = true
                        self.checkMark.isHidden = true
                        UIView.animate(withDuration: 0.2, animations: {
                            self.loader.isHidden = false
                            self.loader.alpha = 1.0
                            self.view.layoutIfNeeded()
                        })
                        self.setTabBarVisible(visible: false, animated: true)
                        self.setupViewsForRippleEffect()
                        self.payment()
                    }
                }
            })
        }
        else {
            // Device cannot use TouchID
        }
    }
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,message: err,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true,completion: nil)
    }
    func payment(){
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.paymentSuccess()
        }
    }
    // function to clear out the blur QR code
    func displayQRCodeImage() {
        let scaleX = qrCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrCode.image = UIImage(ciImage: transformedImage)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
    })
    
    // MARK: - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    func scan() {
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                reader.modalPresentationStyle = .pageSheet
                reader.delegate = self
                reader.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        print("Completion with result: \(result.value) of type \(result.metadataType)")
                        self.receiversAddress.text = result.value
                    }
                }
                present(reader, animated: true, completion: nil)
            }
        } catch let error as NSError {
            switch error.code {
            case -11852:
                let alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            case -11814:
                let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            default:()
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

extension UIViewController {
    func setTabBarVisible(visible: Bool, animated: Bool) {
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        // bail if the current state matches the desired state
        if (isTabBarVisible == visible) { return }
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        // zero duration means no animation
        let duration: TimeInterval = (animated ? 0.3 : 0.0)
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            },completion : {
                (finished:Bool) in if finished == true{
                    self.view.layoutSubviews()
                }
            })
            
        }
    }
    var isTabBarVisible: Bool {
        return (self.tabBarController?.tabBar.frame.origin.y ?? 0) < self.view.frame.maxY
    }
}
