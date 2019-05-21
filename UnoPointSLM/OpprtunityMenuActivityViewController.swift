//
//  OpprtunityMenuActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 07/12/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreLocation

class OpprtunityMenuActivityViewController: UIViewController ,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate{
    
    var locationManager:CLLocationManager!
    var m_strlat = ""
    var m_strlon = ""
    var m_strMainmeuname = ""
    var submenu = [String]()
    var currentItem = ""
    var m_strOID = ""
    var oid = ""

      @IBOutlet weak var subOppmenuTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submenu = [String]()
        
        if(m_strMainmeuname == "OPPRTUNITYMENU"){
//            submenu.append("MEET START")
//            submenu.append("MEET END")
            submenu.append("MEET SCHEDULE")
            submenu.append("MEET RESCHEDULE")
            submenu.append("PROGRESS")
            submenu.append("CREATE RFQ")
            submenu.append("VIEW RFQ")
            submenu.append("PRODUCT")
//            submenu.append("PROPOSAL")
            submenu.append("CREATE QUOTATION")
            submenu.append("CREATE PI")
            submenu.append("REMARK")
            submenu.append("PO")
            submenu.append("CALL BACK")
            submenu.append("EXECUTIVE CLOSE")
            submenu.append("NEW COMUNICATION")
            submenu.append("UPLOAD ATTACHMENT")
//            submenu.append("PROPOSAL")
            
           
        }

        
        subOppmenuTableView.delegate=self
        subOppmenuTableView.dataSource=self
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submenu.count
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        
        
        let cornerRadius: CGFloat = 6.0
        cell.viewcellleadsubmenu.layer.cornerRadius = cornerRadius
        
        cell.viewcellleadsubmenu.layer.masksToBounds = true
        
        // Configure the cell...
        
        
        
        cell.titleLabelforleadsubmenu.text = submenu[indexPath.row]
        cell.titleLabelforleadsubmenu.textColor = (submenu[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = submenu[indexPath.row]
        
        
        if(name == "PRODUCT")
        {
             let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
            secondController.lblaction = "NewProduct"
            secondController.m_strID = m_strOID
//            secondController.m_strlat = m_strlat
//            secondController.m_strlon = m_strlon
            self.navigationController?.pushViewController(secondController, animated: true)


        }
//
//
        if(name == "CREATE QUOTATION")
        {
              let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
             secondController.m_strID = m_strOID
          
            
            secondController.lblaction = "NewProposal"
//            secondController.m_strlat = m_strlat
//            secondController.m_strlon = m_strlon
            self.navigationController?.pushViewController(secondController, animated: true)


        }
//
//        if(name == "ESTIMATE QUOTATION")
//        {
//            let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
//            WebViewController
//            secondController.lblaction = "MDLeadSendEstimatQuatation"
//            secondController.m_strlat = m_strlat
//            secondController.m_strlon = m_strlon
//            self.navigationController?.pushViewController(secondController, animated: true)
//
//
//        }
//
//        if(name == "CONVERT OPPORTUNITIES")
//        {
//            let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
//            WebViewController
//            secondController.lblaction = "LeadToOpp"
//            secondController.m_strlat = m_strlat
//            secondController.m_strlon = m_strlon
//            self.navigationController?.pushViewController(secondController, animated: true)
//
//
//        }
        if(name == "MEET SCHEDULE"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "meetschedule" ) as!
            MeetStartActivityViewController
            
            viewcontroller.m_strID = m_strOID
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
        
        
        if(name == "MEET RESCHEDULE"){
            
//            let viewcontroller = storyboard?.instantiateInitialViewController(withIdentifier: "meetreschedule") as!
//            MeetRescheduleActivityViewController
//            viewcontroller.m_strID = m_strOID
//            self.navigationController?.pushViewController(UIViewController, animated: Bool)
        }
        
        
        
        if(name == "REMARK"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "remark" ) as!
            RemarkSubmitActivityViewController
            
            viewcontroller.m_strID = m_strOID
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }

        
        if(name == "CALL BACK"){
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "oppcallback") as!
            OpportunityCallBackViewController

            viewcontroller.m_strID = m_strOID

            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
//        if(name == "LEAD CLOSE"){
//            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "leadclose") as!
//            LeadCloseActivityViewController
//
//            viewcontroller.leadid = m_strLeadID
//
//            self.navigationController?.pushViewController(viewcontroller, animated: true)
//        }
       
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        m_strlat = String(lat)
        m_strlon = String(lon)
        // lblLocation.text = "Location:"+m_strlat+","+m_strlon
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
