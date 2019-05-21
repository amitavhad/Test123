//
//  WebViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 25/10/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKUIDelegate {
    
     var lblaction:String?

   var webview: WKWebView!
    
    var m_strID = ""
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
//    var locationManager:CLLocationManager!
    var m_strlat = ""
    var m_strlon = ""
    
    var url:URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Getting IPname/version/imei
        
        let preferences = UserDefaults.standard
       
        if preferences.object(forKey: "CustomerUrl") != nil{
            
            m_stripname = preferences.object(forKey: "CustomerUrl") as! String
            m_strappversion = preferences.object(forKey: "Customerappver") as! String
            m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
        }
        if(lblaction == "Help"){
            url = URL(string: m_stripname!+"/MDHelp.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=MDViewImage")
        }
        
        if(lblaction == "MDTargetWiseDashboard"){
            url = URL(string: m_stripname!+"/MDTargetToDoProductvityRevenueHomeScreen.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=MDView")
            
            
        
        }
        
        if(lblaction == "MDView"){
            url = URL(string: m_stripname!+"/MDDailyRoutine.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&leadid=")
            
        }
        
        if(lblaction == "NewOpp"){
            url = URL(string: m_stripname!+"/MDSLTicketAction.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&leadid="+"&lat="+m_strlat+"&lon="+m_strlon)
            
            
        }
        
        
        if(lblaction == "NewLead"){
            
           
        
         url = URL(string: m_stripname!+"/MDLead.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&leadid="+"&lat="+m_strlat+"&lon="+m_strlon)
            //"&lat=11.3333"+"&lon=12.4444"
        }
        if(lblaction == "VIEWLEADDETAILS"){
            url = URL(string: m_stripname!+"/DeviceViewLeadDetails.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&leadid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
           
        }
        
        if(lblaction == "MDLeadProduct"){
            
            url = URL(string: m_stripname!+"/MDLeadProduct.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
            
            
        }
        
        if(lblaction == "MDLeadSendMail"){
            
            url = URL(string: m_stripname!+"/MDLeadSendMail.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
            
          
            
        }
        
        if(lblaction == "MDLeadSendEstimatQuatation"){
            
            url = URL(string: m_stripname!+"/MDLeadEstimatQuatation.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
            
            
        }
        
        
        if(lblaction == "LeadToOpp"){
            url = URL(string: m_stripname!+"/MDLeadEstimatQuatation.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
            
        }
        
        
        if(lblaction == "VIEWMORE"){
            url = URL(string: m_stripname!+"/DeviceViewMore.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&oid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
            
        }
        
        
        if(lblaction == "NewProduct"){
            url = URL(string: m_stripname!+"/MDProduct.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&oid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon)
            
        }
        
        if(lblaction == "NewProposal"){
            url = URL(string: m_stripname!+"/MDProposal.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&oid="+m_strID+"&lat="+m_strlat+"&lon="+m_strlon+"&proposaltype=CreateQuotation")

        }
      
      
        print(url!)
        let request = URLRequest(url: url!)
        
        
        webview.load(request)
        

        // Do any additional setup after loading the view.
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webview = WKWebView(frame: .zero, configuration: webConfiguration)
        webview.uiDelegate = self
        view = webview
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func determineMyCurrentLocation() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//            //locationManager.startUpdatingHeading()
//        }
//    }
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//        
//        
//        let lat = userLocation.coordinate.latitude
//        let lon = userLocation.coordinate.longitude
//        m_strlat = String(lat)
//        m_strlon = String(lon)
//       // lblLocation.text = "Location:"+m_strlat+","+m_strlon
//        //        print("user latitude = \(userLocation.coordinate.latitude)")
//        //        print("user longitude = \(userLocation.coordinate.longitude)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
//    {
//        print("Error \(error)")
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
