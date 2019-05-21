//
//  EnggAvailabilityLogoutController.swift
//  UnoPointSLM
//
//  Created by Amit A on 12/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//
import UIKit


class EnggAvailabilityLogoutController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    
    var m_strLat = ""
    var m_strLon = ""
    
    var earlyoutreason:[EarlyOutReasonmst_eorm]? = nil
//    @IBOutlet weak var earlyreasonpicker: UIPickerView!
    
    @IBOutlet weak var txtSelectEarlyOutReason: UITextField!
    
     var earlyreasonpicker=UIPickerView()
    
    var l_stEarlyOutReason = [String]()
    
    var l_stEarlyOutReasonID = [String] ()
    
    var m_strEarlyReasonID:String?
    
    @IBOutlet weak var lblserverreply: UILabel!
    
    
    @IBOutlet weak var imgunologo: UIImageView!
    @IBOutlet weak var taskProgress: UIProgressView!
    
    @IBOutlet weak var btnsubmit: UIButton!
    
    
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Getting IPname/version/imei
        
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey: "CustomerUrl") != nil{
            
            m_stripname = preferences.object(forKey: "CustomerUrl") as! String
            m_strappversion = preferences.object(forKey: "Customerappver") as! String
            m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
        }
        
        // set image
        self.getImage(imageName: "unopoint.png")
        
        
        
//        self.taskProgress.progress = Float(0.0)
        
        
        txtSelectEarlyOutReason.isHidden = true
        earlyreasonpicker.isHidden = true
        taskProgress.isHidden = true
        btnsubmit.isHidden = true
        
        
        
        
        btnsubmit.setBackgroundImage(UIImage(named: "buttonbg.png"), for: UIControlState.normal)
//        lblserverreply.backgroundColor = UIColor(patternImage: UIImage(named: "hb")!)
        
        punchouttime()
        fillEarlyReason()
        // Do any additional setup after loading the view.
    }
    
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imgunologo.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image!")
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return l_stEarlyOutReason.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return l_stEarlyOutReason[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //todo
        
        txtSelectEarlyOutReason.text=l_stEarlyOutReason[row]
        m_strEarlyReasonID = l_stEarlyOutReasonID[row]
        txtSelectEarlyOutReason.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func punchouttime(){
        
        LoadingIndicatorView.show("Please Wait Checking Total Working Hour...")
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=MobileDevice&subaction=updateavailtime&availtime=logout&lat="+m_strLat+"&lon="+m_strLon
        var reuest = URLRequest(url: URL(string: m_stripname!+"/smsreply.do")!)
        
        //        self.taskProgress.progress = Float(0.30)
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        //        self.taskProgress.progress = Float(0.60)
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
                            
                            
                            if  let reply = blog["Reply"] as? String
                            {
                                //                                print(name1)
                                
                                message = reply
                                
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                if(message == ""){
                    message = "Error Connecting check Internet Connection."
                }
                
                if(message == "Please Select Early Out Time Reason."){
                    self.txtSelectEarlyOutReason.isHidden = false
                    self.earlyreasonpicker.isHidden = false
                    self.taskProgress.isHidden = false
                    self.btnsubmit.isHidden = false
                }
                self.lblserverreply.text = "Server Reply: "+message
                LoadingIndicatorView.hide()
                //                self.taskProgress.progress = Float(1.0)
            }
            
            
            //                        self.btnshowmenu.isHidden=true
            }.resume()
        
        
    }
    
    
    
    //Fill Early Reason Pickerview
    
    
    func fillEarlyReason(){
        
        
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria=earlyouttimereason_eom"
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDLeaveTypeMaster.do")!)
        
        
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        
        URLSession.shared.dataTask(with: reuest)  { (data, response, error) in
            
            var message =  ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                print(error!)
            }else{
                do {
                    CoreDataHandlerForEnggActivity.cleardataForEarlyReasonmst()
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["LeaveType"] as? [[String: Any]] {
                        for blog in blogs {
                            
                            
                            if  let typeID = blog["typeid"] as? String
                            {
                                
                                let typevalue = blog["typevalue"] as? String
                                
                                
                                //                                DispatchQueue.main.async {
                                
                                CoreDataHandlerForEnggActivity.saveObject(typeID: typeID, typeValue: typevalue!,tablename: "EarlyOutReasonmst_eorm")
                                
                                //                                }
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                self.earlyoutreason=CoreDataHandlerForEnggActivity.fetchObjectFromEarlyOutReasonmst()
                
                for i in self.earlyoutreason!{
                    self.l_stEarlyOutReasonID.append(i.typeID!)
                    self.l_stEarlyOutReason.append(i.typeValue!)
                    
                }
                
                
                
                
                self.earlyreasonpicker.delegate = self
                self.earlyreasonpicker.dataSource = self
                self.txtSelectEarlyOutReason.inputView = self.earlyreasonpicker
                
                
                
                
                
            }
            
            
            
            }.resume()
        
        
    }
    
    
    
    
    @IBAction func onclicksubmitResponse(_ sender: Any) {
        
        let selectEarlyOutReason =  txtSelectEarlyOutReason.text
        
        
        //        let selectActivity = txtSelectActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(selectEarlyOutReason == "" || selectEarlyOutReason == "Select"){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Select Early Out Reason", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        createAlert(title: "UnoPoint", message: "Do you Want to submit")
        
    }
    
    
    func  createAlert(title:String,message:String){
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: {(action) in
            self.EarlyOutReasonsubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func EarlyOutReasonsubmit(){
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=MobileDevice&subaction=updateavailtime&availtime=logout&earlyoutreason="+m_strEarlyReasonID!+"&lat="+m_strLat+"&lon="+m_strLon
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/smsreply.do")!)
        
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
                            
                            
                            if  let reply = blog["Reply"] as? String
                            {
                                //                                print(name1)
                                
                                message = reply
                                
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                if(message == ""){
                    message = "Error Connecting check Internet Connection."
                }
                self.lblserverreply.text = "Server Reply: "+message
                self.taskProgress.progress = Float(1.0)
            }
            
            
            //                        self.btnshowmenu.isHidden=true
            }.resume()
        
        
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
