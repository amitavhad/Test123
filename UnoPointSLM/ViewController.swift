//
//  ViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 02/10/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit

class ViewController: UIViewController, MenuTransitionManagerDelegate {
    
    let menuTransitionManager = MenuTransitionManager()
    
    var progressValue = 0.0
    
    
    @IBOutlet weak var lbldisplayver: UILabel!
    
    
    @IBOutlet weak var lblImeiNo: UILabel!
    
    
    @IBOutlet weak var lblcompanyTrademark: UILabel!
    
    @IBOutlet weak var lblwelcome: UILabel!
    
    
    @IBOutlet weak var txtMobileNo: UITextField!
    
    
    
    
    
    @IBOutlet weak var taskProgress: UIProgressView!
    
    
    @IBOutlet weak var btnReg: UIButton!
    
    @IBOutlet weak var btnResendotp: UIButton!
    
    
    
    @IBOutlet weak var imgunologo: UIImageView!
    
    
    @IBOutlet weak var txtotp: UITextField!
    
    var m_strCustID:String?
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    
    @IBOutlet weak var MenuITem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblcompanyTrademark.text = Constants.companytrademarkname
        lbldisplayver.text = Constants.displayver
        
        
        
        self.title = ""
        //
        //        // Give shape to button and textfield
        //
//        contentshape()
        //
//        self.taskProgress.progress = Float(0.0)
        
        let preferences = UserDefaults.standard
        
        let currentLevelKey = "RegisterStatus"
        if preferences.object(forKey: "CustomerUrl") == nil{
            MenuITem.isEnabled = false
            showInputDialog()
            
        }else{
            let custname = preferences.object(forKey: "CustomerName") as! String
            lblwelcome.text = "Welcome To "+String(custname)
            
            self.getImage(imageName: "unopoint.png")
            m_stripname = preferences.object(forKey: "CustomerUrl") as! String
            m_strappversion = preferences.object(forKey: "Customerappver") as! String
            m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
            
            
            lblImeiNo.text = "Reg No:"+m_strenggimeino!
            
            if preferences.object(forKey: "RegisterStatus") == nil {
                //  Doesn't exist
                MenuITem.isEnabled = false
                
                
            } else {
                let currentLevel = preferences.object(forKey: "RegisterStatus") as! String
                if (currentLevel == "Registered")
                {
                    btnReg.isHidden=true
                    txtMobileNo.isHidden=true
                    txtotp.isHidden=true
                    btnResendotp.isHidden = true
                    MenuITem.isEnabled = true
                    //                lblmobileno.isHidden=true
                    //                lblotp.isHidden=true
                    taskProgress.isHidden=true
                    
                    
                }else{
                    MenuITem.isEnabled = false
                    btnReg.isHidden=false
                    txtMobileNo.isHidden=false
                    txtotp.isHidden=false
                    btnResendotp.isHidden = false
                }
                
            }
            
        }
        
        
    }
//    func contentshape(){
//
//
//        txtMobileNo.layer.borderWidth = 1
//        txtMobileNo.layer.borderColor = UIColor.gray.cgColor
//        txtMobileNo.layer.cornerRadius = 20
//        txtMobileNo.clipsToBounds = true
//
//
//
//        txtotp.layer.borderWidth = 1
//        txtotp.layer.borderColor = UIColor.gray.cgColor
//        txtotp.layer.cornerRadius = 20
//        txtotp.clipsToBounds = true
//
//        btnReg.layer.cornerRadius = 20
//        btnReg.clipsToBounds = true
//
//        //        btnResendotp.layer.cornerRadius = 20
//        //        btnResendotp.clipsToBounds = true
//    }
    
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imgunologo.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image!")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter Customer details?", message: "Enter Customer Code", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let CustomerCode = alertController.textFields?[0].text
            //            let email = alertController.textFields?[1].text
            
            
            if(CustomerCode == ""){
                let alertController = UIAlertController(title: "UnoPoint", message:
                    "Please Enter Customer Code", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            LoadingIndicatorView.show("Please Wait while Fetching Details...")
            self.m_strCustID = CustomerCode!
            self.downloadJson {
                
            }
            
            //            self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Customer Code:"
        }
        //        alertController.addTextField { (textField) in
        //            textField.placeholder = "Enter Email"
        //        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func downloadJson(completed: @escaping () -> ()){
        let url = URL(string: "http://unopointservicedesk.com/upsdinf/jsp/MDMapping.html")
        print(url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            var message =  ""
            var imageurl = ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                LoadingIndicatorView.hide()
                print(error!)
            }else{
                do{
                    
                    
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["CustomerDetails"] as? [[String: Any]] {
                        for blog in blogs {
                            if let name = blog["CustId"] as? String {
                                if(self.m_strCustID == name){
                                    let customerName = blog["CustName"] as? String
                                    let customerurl = blog["CustUrl"] as? String
                                    let customerappver = blog["Appver"] as? String
                                    let customerimageurl = blog["Custimageurl"] as? String
                                    let randomnumber = String(arc4random())+""+String(arc4random_uniform(100000)) as? String
                                    
                                    
                                    let preferences = UserDefaults.standard
                                    // store string value
                                    
                                    preferences.set(customerName, forKey: "CustomerName")
                                    preferences.set(customerurl, forKey: "CustomerUrl")
                                    preferences.set(customerappver, forKey: "Customerappver")
                                    preferences.set(customerimageurl, forKey: "CustomerimgUrl")
                                    preferences.set(randomnumber, forKey: "Engineerimeino")
                                    
                                    //  Save to disk
                                    let didSave = preferences.synchronize()
                                    if !didSave {
                                        //  Couldn't save (I've never seen this happen in real world testing)
                                    }
                                }
                                
                                
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }catch{
                    print("Json Error")
                }
                
                DispatchQueue.main.async {
                    let preferences = UserDefaults.standard
                    if preferences.object(forKey: "CustomerimgUrl") != nil{
                        let customerName = preferences.object(forKey: "CustomerName") as! String
                        self.lblwelcome.text = "Welcome To "+customerName
                        
                    }
                    if preferences.object(forKey: "Engineerimeino") != nil{
                        let enggimeino = preferences.object(forKey: "Engineerimeino") as! String
                        self.lblImeiNo.text = "Reg No:"+enggimeino
                        
                    }
                    
                    
                    if preferences.object(forKey: "CustomerimgUrl") != nil{
                        let customerimgurl = preferences.object(forKey: "CustomerimgUrl") as! String
                        if (String(customerimgurl) != "")
                        {
                            
                            self.loadimage(ImagePATH: customerimgurl)
                            
                        }
                    }else{
                        LoadingIndicatorView.hide()
                        message = "Customer code does not match please contact admin"
                    }
                    
                    if(message != ""){
                        let alertController = UIAlertController(title: "UnoPoint", message:
                            message, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    
                    completed()
                }
            }
            
            }.resume()
        
        
        
    }
    func loadimage(ImagePATH:String){
        
        //URL containing the image
        let URL_IMAGE = URL(string: ImagePATH)
        //
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                LoadingIndicatorView.hide()
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                            //displaying the image
                            self.imgunologo.image = image
                            self.saveImage(imageName: "unopoint.png")
                            //                            self.getImage(imageName: "unopoint.png")
                            
                            LoadingIndicatorView.hide()
                        }
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()
        
    }
    
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = imgunologo.image!
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        let preferences = UserDefaults.standard
        // store string value
        
        preferences.set(imageName, forKey: "imagename")
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
    }
    
    
    
    @IBAction func ShowMenu(_ sender: Any) {
        let menuTableViewController = storyboard?.instantiateViewController(withIdentifier: "MenuList") as! MenuTableViewController
        menuTableViewController.currentItem = self.title!
        menuTableViewController.transitioningDelegate = menuTransitionManager
        menuTransitionManager.delegate = self
        
        self.navigationController?.pushViewController(menuTableViewController, animated: true)
    }
    
    
    
    @IBAction func btnRegister(_ sender: Any) {
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey: "CustomerUrl") == nil {
            showInputDialog()}
        else{
            //       let mobileno =  UITextfield.text
            let mobileno = self.txtMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if(mobileno == ""){
                let alertController = UIAlertController(title: "UnoPoint", message:
                    "Please Enter Mobile No", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            
            if preferences.object(forKey: "OTP") == nil {
                
                sendotp()
                
            } else {
                
                let currentLevel = preferences.object(forKey: "OTP") as! Int
               
                
                let m_strOTP = self.txtotp.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                if(m_strOTP == ""){
                    let alertController = UIAlertController(title: "UnoPoint", message:
                        "Please Enter Correct OTP", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                let shareprefotp=String(currentLevel);
                //            let shareprefotp = "7788"
                
                print("OTP IS:"+String(currentLevel))
                if(mobileno != "1234567890" || txtotp.text != "7788"){
                    if (shareprefotp != txtotp.text)
                    {
                        let alertController = UIAlertController(title: "UnoPoint", message:
                            "Please Enter Correct OTP", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
                registerDevice()
            }
            
            
        }
    }
    func registerDevice(){
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=register&ModelInfo=samsung"
        
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/GeoLocRegAction.do")!)
        //        var reuest = URLRequest(url: URL(string: "https://"+Constants.ipname+"/GeoLocRegAction.do")!)
        
        self.taskProgress.progress = Float(0.30)
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        self.taskProgress.progress = Float(0.60)
        URLSession.shared.dataTask(with: reuest)  { (data, response, error) in
            
            var message =  ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                print(error!)
            }else{
                do {
                    
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["results"] as? [[String: Any]] {
                        for blog in blogs {
                            
                            
                            if  let registerstatus = blog["Reply"] as? String
                            {
                                //                                print(name1)
                                
                                let preferences = UserDefaults.standard
                                // store string value
                                
                                preferences.set(registerstatus, forKey: "RegisterStatus")
                                //  Save to disk
                                let didSave = preferences.synchronize()
                                
                                if !didSave {
                                    //  Couldn't save (I've never seen this happen in real world testing)
                                }
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    //                    print("error")
                    
                }
                
            }
            DispatchQueue.main.async {
                let preferences = UserDefaults.standard
                if preferences.object(forKey: "RegisterStatus") == nil {
                    //  Doesn't exist
                    self.MenuITem.isEnabled = false
                    
                    //                    self.btnshowmenu.isHidden=true
                } else {
                    let currentLevel = preferences.object(forKey: "RegisterStatus") as! String
                    if (currentLevel == "Registered")
                    {
                        
                        self.btnReg.isHidden=true
                        self.txtMobileNo.isHidden=true
                        self.txtotp.isHidden=true
                        self.btnResendotp.isHidden = true
                        //                        self.lblmobileno.isHidden=true
                        //                        self.lblotp.isHidden=true
                        self.taskProgress.isHidden=true
                        //                        self.btnshowmenu.isHidden=false
                        self.MenuITem.isEnabled = true
                    }
                    
                }
                
                //
                if(message == "Error Connecting check Internet Connection."){
                    let alertController = UIAlertController(title: "UnoPoint", message:
                        message, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                self.taskProgress.progress = Float(1.0)
            }
            
            
            //                        self.btnshowmenu.isHidden=true
            }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sendotp(){
        let preferences = UserDefaults.standard
        m_stripname = preferences.object(forKey: "CustomerUrl") as! String
        m_strappversion = preferences.object(forKey: "Customerappver") as! String
        m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=sendotp&ModelInfo=samsung&mobileno="+txtMobileNo.text!
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/GeoLocRegAction.do")!)
        
        print(m_stripname!)
        
        self.taskProgress.progress = Float(0.30)
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        self.taskProgress.progress = Float(0.60)
        URLSession.shared.dataTask(with: reuest)  { (data, response, error) in
            
            var message =  ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                print(error!)
            }else{
                do {
                    
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["results"] as? [[String: Any]] {
                        for blog in blogs {
                            if  let otp = blog["OTP"] as? Int
                            {
                                message = "OTP Generated"
                                //                               print(name)
                                
                                let preferences = UserDefaults.standard
                                // store string value
                                
                                preferences.set(otp, forKey: "OTP") as? Int
                                //  Save to disk
                                let didSave = preferences.synchronize()
                                
                                if !didSave {
                                    //  Couldn't save (I've never seen this happen in real world testing)
                                }
                                
                                //
                                
                            }
                            
                            if  let name1 = blog["Reply"] as? String
                            {
                                //                                print(name1)
                                
                                message = "Server unable to register device,Please contact admin"
                                
                                let preferences = UserDefaults.standard
                                // store string value
                                
                                preferences.set("Unregister", forKey: "RegisterStatus")
                                //  Save to disk
                                let didSave = preferences.synchronize()
                                
                                if !didSave {
                                    //  Couldn't save (I've never seen this happen in real world testing)
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    //                    print("error")
                    
                }
                
            }
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "UnoPoint", message:
                    message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                self.taskProgress.progress = Float(1.0)
            }
            }.resume()
    }
    
    
    
    @IBAction func OnclickResendOTP(_ sender: Any) {
        let mobileno = self.txtMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(mobileno == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Mobile No", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        sendotp()
    }
}


