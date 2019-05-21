//
//  OppDetailsActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 07/12/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit

class OppDetailsActivityViewController: UIViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    var oid = ""

    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var OppTableView: UITableView!
    
    
    @IBOutlet weak var lblOpp: UILabel!
    var oppdetails:[Ticketview_tv]? = nil
      var details = [String]()
    
    @IBAction func ShowEnggMenu(_ sender: Any) {
        
        
        let  secondController = storyboard?.instantiateViewController(withIdentifier: "oppmenu") as! OpprtunityMenuActivityViewController
        
        secondController.m_strMainmeuname = "OPPRTUNITYMENU"
        secondController.m_strOID = oid
        self.navigationController?.pushViewController(secondController, animated: true)

        
        
        
    }
    
    @IBAction func btnviewmore(_ sender: Any) {
        
        let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
        secondController.m_strID = oid
        secondController.lblaction = "VIEWMORE"
        self.navigationController?.pushViewController(secondController, animated: true)

        
    }
    override func viewDidLoad() {
        
        lblOpp.text="Opp ID: "+oid
        
//        OppTableView.delegate=self
//        OppTableView.dataSource=self
        
        self.getImage(imageName: "unopoint.png")
        super.viewDidLoad()
        
        oppdetails =  CoreDataHandlerforOppView.filterData(lid: oid)
        for i in oppdetails!{
            details.append("Customer Name: "+i.customername2_tv!)
            details.append("Lead ID: "+i.leadid_tv!)
            details.append("Exec Name: "+i.engineername_tv!)
            details.append("Exec Contact: "+i.engineercontactno_tv!)
//            details.append("Order Value: "+i.orderva!)
//            details.append("Internal Progress Name: "+i.executivecontactno_lv!)
//            details.append("External Progress Name: "+i.ordervalue_lv!)
//            details.append("Opp Type: "+i.leadsource_lv!)
//            details.append("Status: "+i.leaddate_lv!)
//            details.append("Date Time: "+i.leadtime_lv!)
//            details.append("Customer Address: "+i.leadclosedate_lv!)
//            details.append("Age: "+i.leadclosetime_lv!)
//            details.append("Assigned Date: "+i.description_lv!)
//            details.append("Custom1: "+i.detail_lv!)
//            details.append("Last Meet: "+i.productcategory_lv!)
//            details.append("Contact Person: "+i.productsubcategory_lv!)
//            details.append("Contact No: "+i.custtype_lv!)
//            details.append("Created By: "+i.customeraddress_lv!)
//            details.append("Product Approval Status: "+i.state_lv!)
           
            
        }

        // Do any additional setup after loading the view.
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
