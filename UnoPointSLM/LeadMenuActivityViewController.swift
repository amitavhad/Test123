//
//  LeadMenuActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 20/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreLocation
    class LeadMenuActivityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
        var locationManager:CLLocationManager!
        var m_strlat = ""
        var m_strlon = ""
        var m_strMainmeuname = ""
        var submenu = [String]()
        var currentItem = ""
        var m_strLeadID = ""
        @IBOutlet weak var subLeadmenuTableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            
            submenu = [String]()
        
            if(m_strMainmeuname == "LEADMENU"){
                submenu.append("CALL TRACK")
                submenu.append("CALL BACK")
                submenu.append("LEAD CLOSE")
                submenu.append("CONVERT OPPORTUNITIES")
                submenu.append("PRODUCT")
                submenu.append("SEND MAIL")
                submenu.append("ESTIMATE QUOTATION")
                
            }
            
            
            subLeadmenuTableView.delegate=self
            subLeadmenuTableView.dataSource=self
            // Do any additional setup after loading the view, typically from a nib.
            
            // Get Location
            
            determineMyCurrentLocation()
        }
        //    @IBAction func maximizeButtonTapped(sender: AnyObject) {
        //        maximizeToFullScreen()
        //    }
        //
        //    @IBAction func cancelButtonTapped(sender: AnyObject) {
        //        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
        //            delegate.interactiveDismiss = false
        //        }
        //
        //        dismiss(animated: true, completion: nil)
        //    }
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
                let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
                WebViewController
                secondController.lblaction = "MDLeadProduct"
                secondController.m_strlat = m_strlat
                secondController.m_strlon = m_strlon
                self.navigationController?.pushViewController(secondController, animated: true)
                
                
            }
            
            
            if(name == "SEND MAIL")
            {
                let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
                WebViewController
                secondController.lblaction = "MDLeadSendMail"
                secondController.m_strlat = m_strlat
                secondController.m_strlon = m_strlon
                self.navigationController?.pushViewController(secondController, animated: true)
                
                
            }
            
            if(name == "ESTIMATE QUOTATION")
            {
                let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
                WebViewController
                secondController.lblaction = "MDLeadSendEstimatQuatation"
                secondController.m_strlat = m_strlat
                secondController.m_strlon = m_strlon
                self.navigationController?.pushViewController(secondController, animated: true)
                
                
            }
            
            if(name == "CONVERT OPPORTUNITIES")
            {
                let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
                WebViewController
                secondController.lblaction = "LeadToOpp"
                secondController.m_strlat = m_strlat
                secondController.m_strlon = m_strlon
                self.navigationController?.pushViewController(secondController, animated: true)
                
                
            }
            if(name == "CALL TRACK"){
                let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "leadcalltrack") as!
                LeadCallTrackActivityViewController
                viewcontroller.leadid = m_strLeadID
                
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            if(name == "CALL BACK"){
                let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "leadcallback") as!
                LeadCallBackActivityViewController
                
                 viewcontroller.leadid = m_strLeadID
                
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            if(name == "LEAD CLOSE"){
                let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "leadclose") as!
                LeadCloseActivityViewController
                
                 viewcontroller.leadid = m_strLeadID
                
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            
            
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
            // lblLocation.text = "Location:"+m_strlat+","+m_strlon
            //        print("user latitude = \(userLocation.coordinate.latitude)")
            //        print("user longitude = \(userLocation.coordinate.longitude)")
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error \(error)")
        }
        
        
}
