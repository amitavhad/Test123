//
//  EnggAvailabilityLoginController.swift
//  UnoPointSLM
//
//  Created by Amit A on 12/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit

class EnggAvailabilityLoginController: UIViewController {
    
    @IBOutlet weak var imgunologo: UIImageView!
    var m_strLat = ""
    var m_strLon = ""
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    
    
    @IBOutlet weak var lblserverreply: UILabel!
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
        punchintime()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func punchintime(){
        
        LoadingIndicatorView.show("Please Wait while Login Processing...")
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=MobileDevice&subaction=updateavailtime&availtime=login&lat="+m_strLat+"&lon="+m_strLon
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
                LoadingIndicatorView.hide()
                //                self.taskProgress.progress = Float(1.0)
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
