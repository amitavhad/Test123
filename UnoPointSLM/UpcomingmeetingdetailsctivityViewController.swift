//
//  UpcomingmeetingdetailsctivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 15/02/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit

class UpcomingmeetingdetailsctivityViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var UpcomingmeetingdetailsTableView: UITableView!
    
    var currentItem = ""
    var action = ""
    
    var oid = ""
    var executivename = ""
    var customername = ""
    
    
    
    var upcomingmeetingdetails:[Upmeeting_umv]? = nil
    var completedgmeetingdetails:[Completedmeetingview_cmv]? = nil
    var details = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpcomingmeetingdetailsTableView.delegate=self
        UpcomingmeetingdetailsTableView.dataSource=self
        
        if(action == "Upcoming"){
            
            upcomingmeetingdetails =  CoreDataHandlerforUpcomingmeetingview.filterData(oid: oid, executivename: executivename, custname: customername)
            for i in upcomingmeetingdetails!{
                details.append("Opp ID: "+i.tickedid_umv!)
                details.append("Executive Name: "+i.executivename_umv!)
                details.append("Customer Name: "+i.custname_umv!)
                details.append("Schedule Date: "+i.scheduldedate_umv!)
                details.append("Schedule Time: "+i.scheduldetime_umv!)
                details.append("Schedule Comment: "+i.schedulecomment_umv!)
                details.append("Details: "+i.details_umv!)
                details.append("Order Value: "+i.ordervalue_umv!)
                details.append("City: "+i.city_umv!)
                details.append("State: "+i.state_umv!)
                details.append("Address: "+i.address_umv!)
                
                
            }
        }
        if(action == "Completed"){
            completedgmeetingdetails =  CoreDataHandlerforCompletedmeetingview.filterData(oid: oid, executivename: executivename, custname: customername)
            for i in completedgmeetingdetails!{
                details.append("Opp ID: "+i.ticketid_cmv!)
                details.append("Executive Name: "+i.executivename_cmv!)
                details.append("Customer Name: "+i.custname_cmv!)
                details.append("Meeting Date: "+i.meetingdate_cmv!)
                details.append("Meeting StartTime: "+i.meetingstarttime_cmv!)
                details.append("Meeting EndTime: "+i.meetingendtime_cmv!)
                details.append("Meeting Duration: "+i.meetingduration_cmv!)
                details.append("Meeting Comment: "+i.meetingcomment_cmv!)
                details.append("Details: "+i.details_cmv!)
                details.append("Order value: "+i.ordervalue_cmv!)
                details.append("Action Reqiured: "+i.actionreqiured_cmv!)
                details.append("Meeting Place: "+i.meetingplace_cmv!)
                details.append("Customer Address: "+i.address_cmv!)
                
                
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UpcomingmeetingdetailsTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        //
        
        
        
        let cornerRadius: CGFloat = 6.0
        
        
        // Configure the cell...
        
        
        
        cell.lblUpcomingmeetingDetails.text=details[indexPath.row]
        cell.lblUpcomingmeetingDetails.textColor = (details[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        
        return cell
        
        
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
