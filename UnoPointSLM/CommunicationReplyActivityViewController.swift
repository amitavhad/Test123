//
//  CommunicationReplyActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 14/03/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit
import CoreLocation

class CommunicationReplyActivityViewController: UIViewController ,CLLocationManagerDelegate{
    var oid = ""
    var cid = ""
    var m_strMsgTo = ""
    
    
    
    @IBOutlet weak var lbloppid: UILabel!
    
    @IBOutlet weak var txtmsgto: UITextField!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblserverreply: UILabel!
    
    @IBOutlet weak var imgunologo: UIImageView!
    @IBOutlet weak var taskProgress: UIProgressView!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    var locationManager:CLLocationManager!
    
    var m_strlat = ""
    var m_strlon = ""
    
    
    @IBOutlet weak var txtmessage: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbloppid.text = "Opp ID:"+oid
        txtmsgto.text = m_strMsgTo
        
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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imgunologo.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image!")
        }
    }
    @IBAction func onclickSubmitResponse(_ sender: Any) {
        let Message = txtmessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(Message == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Message", preferredStyle: UIAlertControllerStyle.alert)
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
            self.CommunicationReplyActivitysubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func CommunicationReplyActivitysubmit(){
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lat="+m_strlat+"&lon="+m_strlon+"&action=Reply&oid="+oid+"&cid="+cid+"&EngTo="+m_strMsgTo+"&message="+txtmessage.text!
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDCommunication.do")!)
        print(reuest)
        print(parameters)
        
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
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        if let results = json["Reply"] as? [[String: Any]]  {
                            for case let result in (json["Reply"] as? String)! {
                                
                                message =  (json["Reply"] as? String)!
                            }
                            
                        }
//                        if let results = json["results"] as? [[String: Any]]  {
//
//                            for blog in results {
                        
                                
                                if  let reply = json["Reply"] as? String
                                {
                                    
                                    
                                    message = reply
                                    
                                    
                                    
                                    
                                    
//                                }
//                                
//                            }
                            
                            
                            
                            
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

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
