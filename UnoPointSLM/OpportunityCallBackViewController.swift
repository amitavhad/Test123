//
//  OpportunityCallBackViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 21/12/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreLocation

class OpportunityCallBackViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var lblcompanyTrademark: UILabel!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    var locationManager:CLLocationManager!
    
    var m_strlat = ""
    var m_strlon = ""
    var m_strOID = ""
    var m_strID  = ""
    
    @IBOutlet weak var imgunologo: UIImageView!
    
    @IBOutlet weak var lblOID: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    var m_strDate = ""
    var m_strTime = ""
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var txtRemarks: UITextField!
    
    @IBOutlet weak var taskProgress: UIProgressView!
    
    
    @IBOutlet weak var lblserverreply: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblOID.text = "OID:"+m_strID
        
        
        lblcompanyTrademark.text = Constants.companytrademarkname
        
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey: "CustomerUrl") != nil{
            
            m_stripname = preferences.object(forKey: "CustomerUrl") as! String
            m_strappversion = preferences.object(forKey: "Customerappver") as! String
            m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
        }
        
        
        
        
        // set image
        self.getImage(imageName: "unopoint.png")
        
        // Get Location
        
        determineMyCurrentLocation()
        
        let dateFormatter = DateFormatter();
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "ddMMyyyy"
        m_strDate = dateFormatter.string(from: datePicker.date)
        
        print("Date:"+m_strDate)
        
        // This Logic only for Time Convert in 24 hour
        // For From Time
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        var timeASString = TimeFormatter.string(from: timePicker.date)
        let time = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm:ss"
        m_strTime =  TimeFormatter.string(from: time!)
        print("From Time:"+m_strTime)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func dateSelectedFromDatePicker(_ sender: Any) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        m_strDate = dateFormatter.string(from: datePicker.date)
        
        print("Date:"+m_strDate)
        
        
        
        
        
    }
    
    
    @IBAction func timeSelectedTimePicker(_ sender: Any) {
        // This Logic only for Time Convert in 24 hour
        
        // For From Time
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        let timeASString = TimeFormatter.string(from: timePicker.date)
        let time = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm:ss"
        m_strTime =  TimeFormatter.string(from: time!)
        print("From Time:"+m_strTime)
        // logic end
        
    }
    
    
    @IBAction func onclickSubmitResponse(_ sender: Any) {
        
        let Remark = txtRemarks.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(Remark == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Remark", preferredStyle: UIAlertControllerStyle.alert)
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
            self.OppCallBacksubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func OppCallBacksubmit(){
        
        //    let parameters = ""
        //
        
        //        let m_strDay=.text
        //        let replacedDay = m_strDay?.replacingOccurrences(of: "/", with: "")
        //
        //        let m_strTime = lblTime.text
        //        let replacedtime = m_strTime?.replacingOccurrences(of: ":", with: "")
        //
        //        let  m_strMessage = "KSYS ETA " + tid! + " " + replacedDay! + replacedtime!
        
        //        var m_strDateTime = m_strDate+m_strFromTime+m_strToTime
        
        
        
        
        
        
        
//        let m_strMessage = "KSYS schedule"+m_strID+" "+m_strDate+m_strTime
        
                let  m_strStatus = "CallBackOpp"
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lat="+m_strlat+"&lon="+m_strlon+"&StatusName="+m_strStatus+"&Remarks="+txtRemarks.text!+"Opp_ID="+m_strID+"Date="+m_strDate+"Time="+m_strTime
        
        
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDOppCallBack.do")!)
        
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
                if(message == "UnRegister"){
                    let preferences = UserDefaults.standard
                    // store string value
                    
                    preferences.set("Unregister", forKey: "RegisterStatus")
                    preferences.set("", forKey: "OTP") as? Int
                    //  Save to disk
                    let didSave = preferences.synchronize()
                    
                    if !didSave {
                        //  Couldn't save (I've never seen this happen in real world testing)
                    }
                }
                self.lblserverreply.text = "Server Reply: "+message
                self.taskProgress.progress = Float(1.0)
            }
            
            
            //                        self.btnshowmenu.isHidden=true
            }.resume()
        
        
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
    //location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        m_strlat = String(lat)
        m_strlon = String(lon)
        lblLocation.text = "Location:"+m_strlat+","+m_strlon
        //        print("user latitude = \(userLocation.coordinate.latitude)")
        //        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
