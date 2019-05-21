//
//  ModalViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 22/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreLocation



class ModalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var m_strlat = ""
    var m_strlon = ""
    var m_strMainmeuname = ""
    var submenu = [String]()
    var currentItem = ""
    var m_strNewOpportunity = ""
    @IBOutlet weak var submenuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submenu = [String]()
        if(m_strMainmeuname == "MY AVAILABILITY"){
            submenu.append("LOGIN")
            submenu.append("LOGOUT")
            submenu.append("LEAVES")
        }
        if(m_strMainmeuname == "LEAD"){
            submenu.append("VIEW LEAD")
            submenu.append("NEW LEAD")
            
        }
        
        if(m_strMainmeuname == "OPPORTUNITY"){
            submenu.append("VIEW OPPORTUNITIES")
            submenu.append("INACTIVE NEW OPPORTUNITIES")
            submenu.append("NEW OPPORTUNITY")
            
            
            
            
            
            
        }
        if(m_strMainmeuname == "MEETING TRACKER"){
            submenu.append("UPCOMING")
            submenu.append("COMPLETED")
            
            
        }
        if(m_strMainmeuname == "TO DO"){
            submenu.append("VIEW TO DO")
            submenu.append("ADD TO DO")
            
            
        }
        if(m_strMainmeuname == "CLAIM MANAGEMENT"){
            submenu.append("VIEW MY CLAIMS")
            submenu.append("VIEW APPROVALS")
            submenu.append("NEW CLAIM(PERIODIC)")
            
            
        }
        
        
        if(m_strMainmeuname == "SETTING"){
            submenu.append("MENU")
            
            
        }
        if(m_strMainmeuname == "LEADMenu"){
            submenu.append("CALL TRACK")
            submenu.append("CALL BACK")
            submenu.append("LEAD CLOSE")
            submenu.append("CONVERT OPPORTUNITIES")
            submenu.append("PRODUCT")
            submenu.append("SEND MAIL")
            submenu.append("ESTIMATE QUOTATION")
            
        }
        
        
        submenuTableView.delegate=self
        submenuTableView.dataSource=self
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
        cell.viewcellsubmenu.layer.cornerRadius = cornerRadius
        
        cell.viewcellsubmenu.layer.masksToBounds = true
        
        // Configure the cell...
        
        
        
        cell.titleLabelforsubmenu.text = submenu[indexPath.row]
        cell.titleLabel.textColor = (submenu[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = submenu[indexPath.row]
        
        if(name == "MENU"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "view") as! SettingTableViewController
            
            viewcontroller.modalPresentationStyle = .fullScreen
            
            
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
        
        
        if(name == "NEW OPPORTUNITY"){
            let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
            secondController.lblaction = "NewOpp"
            self.navigationController?.pushViewController(secondController, animated: true)
        }
        
        if(name == "NEW LEAD")
        {
            let secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as!
            WebViewController
            secondController.lblaction = "NewLead"
            secondController.m_strlat = m_strlat
            secondController.m_strlon = m_strlon
            self.navigationController?.pushViewController(secondController, animated: true)
            
            
        }
        
        if (name == "LOGIN"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "EnggAvailLogin") as!
            EnggAvailabilityLoginController
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
        if (name == "LOGOUT"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "EnggAvailLogout") as!
            EnggAvailabilityLogoutController
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
        if (name == "LEAVES"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "EnggLeave") as!
            EnggAvailabilityLeavesController
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
        if (name == "VIEW LEAD"){
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "viewlead") as!
            LeadViewActivityController
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
        if (name == "VIEW OPPORTUNITIES"){
//
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "viewopportunity") as!
            OpportunitiesViewActivityController

            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
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
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        if(name == "CALL BACK"){
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "demo") as!
            ParentViewController
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        if(name == "UPCOMING"){
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "upcomingmeeting") as!
            UpcomingMeetingActivityViewController
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        if(name == "COMPLETED"){
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "completedmeeting") as!
            CompletedMeetingActivityViewController
            
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
