//
//  LeadDetailsActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 19/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit

class LeadDetailsActivityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var lid = ""
    var currentItem = ""
    var m_strExecutiveNumber = ""
    var m_strCustomerContactNo1 = ""
    var m_strCustomerContactNo2 = ""
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leaddetailsTableView: UITableView!
    
    
    @IBOutlet weak var lblLead: UILabel!
    
    var leaddetails:[Leadview_lv]? = nil
    
    var details = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblLead.text="Lead ID: "+lid
        
        leaddetailsTableView.delegate=self
        leaddetailsTableView.dataSource=self
        
        self.getImage(imageName: "unopoint.png")
        
        leaddetails =  CoreDataHandlerforLeadView.filterData(lid: lid)
        for i in leaddetails!{
            details.append("OppurtunityID: "+i.oppurtunityid_lv!)
            details.append("BusinessUnit: "+i.businessunit_lv!)
            details.append("Status: "+i.status_lv!)
            details.append("CustomerName: "+i.customername_lv!)
            details.append("Executive: "+i.executivename_lv!)
            details.append("ExecutiveNumber: "+i.executivecontactno_lv!)
            details.append("OrderValue: "+i.ordervalue_lv!)
            details.append("LeadSource: "+i.leadsource_lv!)
            details.append("LeadDate: "+i.leaddate_lv!)
            details.append("LeadTime: "+i.leadtime_lv!)
            details.append("LeadCloseDate: "+i.leadclosedate_lv!)
            details.append("LeadCloseTime: "+i.leadclosetime_lv!)
            details.append("Description: "+i.description_lv!)
            details.append("Detail: "+i.detail_lv!)
            details.append("ProductCategory: "+i.productcategory_lv!)
            details.append("ProductSubCategory: "+i.productsubcategory_lv!)
            details.append("CustomerType: "+i.custtype_lv!)
            details.append("Customer Address: "+i.customeraddress_lv!)
            details.append("State: "+i.state_lv!)
            details.append("City: "+i.city_lv!)
            details.append("CustomerContactName1: "+i.customercontactname1_lv!)
            details.append("Emailid1: "+i.emailid1_lv!)
            details.append("CustomerContactNo1: "+i.customercontactno1_lv!)
            details.append("CustomerContactName2: "+i.customercontactname2_lv!)
            details.append("Emailid2: "+i.emailid2_lv!)
            details.append("CustomerContactNo2: "+i.customercontactno2_lv!)
            details.append("CreatedByExecutive: "+i.createdbyexecutive_lv!)
            details.append("Designation1: "+i.designation1_lv!)
            details.append("Disposition: "+i.disposition_lv!)
            details.append("DispositionDescription: "+i.dispositiondescription_lv!)
            details.append("Designation2: "+i.designation2_lv!)
            details.append("CallBackDate: "+i.callbackdate_lv!)
            details.append("CreatedByRole: "+i.createdbyrole_lv!)
            details.append("OpportunityStatus: "+i.opportunitystatus_lv!)
            details.append("PostalCode: "+i.postalcode_lv!)
            details.append("Remarks1: "+i.remarks1_lv!)
            details.append("Remarks2: "+i.remarks2_lv!)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imageView.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=leaddetailsTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        //
        
        
        
        let cornerRadius: CGFloat = 6.0
        
        
        // Configure the cell...
        
        
        
        cell.lblDetails.text=details[indexPath.row]
        cell.lblDetails.textColor = (details[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(details[indexPath.row].contains("ExecutiveNumber:") || details[indexPath.row].contains("CustomerContactNo1:") || details[indexPath.row].contains("CustomerContactNo2:")){
            if(details[indexPath.row].contains("ExecutiveNumber Contact No:") ){
                if(m_strExecutiveNumber == ""){
                    let alertController = UIAlertController(title: "UnoPoint", message:
                        "Can Not Dial,No Phone Number", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            if(details[indexPath.row].contains("CustomerContactNo1:") ){
                if(m_strCustomerContactNo1 == ""){
                    let alertController = UIAlertController(title: "UnoPoint", message:
                        "Can Not Dial,No Phone Number", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            if(details[indexPath.row].contains("CustomerContactNo2:") ){
                if(m_strCustomerContactNo2 == ""){
                    let alertController = UIAlertController(title: "UnoPoint", message:
                        "Can Not Dial,No Phone Number", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            
            if(details[indexPath.row].contains("ExecutiveNumber:") ){
                
                if let url = NSURL(string: "tel://\(m_strExecutiveNumber)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }}
            
            if(details[indexPath.row].contains("CustomerContactNo1:") ){
                
                if let url = NSURL(string: "tel://\(m_strCustomerContactNo1)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
                
            }
            if(details[indexPath.row].contains("CustomerContactNo2:") ){
                
                if let url = NSURL(string: "tel://\(m_strCustomerContactNo2)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
                
            }
            
        }
    }
    
    @IBAction func ShowEnggMenu(_ sender: Any) {
        let  secondController = storyboard?.instantiateViewController(withIdentifier: "leadmenu") as! LeadMenuActivityViewController
        secondController.m_strMainmeuname = "LEADMENU"
        secondController.m_strLeadID = lid
        self.navigationController?.pushViewController(secondController, animated: true)
        
    }
    
    
    
    @IBAction func btnviewmore(_ sender: Any) {
        let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
        secondController.m_strID = lid
        secondController.lblaction = "VIEWLEADDETAILS"
        self.navigationController?.pushViewController(secondController, animated: true)
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
