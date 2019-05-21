//
//  CommunicationDetailsActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 14/03/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit

    class CommunicationDetailsActivityViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
        var oid = ""
        var cid = ""
        var m_strMsgTo = ""
        
        @IBOutlet weak var CommunicationdetailsTableView: UITableView!
        
        var currentItem = ""
        var action = ""
        
       
        var executivename = ""
        var customername = ""
        
        
        
        var communicationetails:[Communicationviewmaster_cm]? = nil
       
        var details = [String]()
        override func viewDidLoad() {
            super.viewDidLoad()
            
            CommunicationdetailsTableView.delegate=self
            CommunicationdetailsTableView.dataSource=self
            
            
                
                communicationetails =  CoreDataHandlerforCommunicationview.filterData(oid: oid,cid: cid)
                for i in communicationetails!{
                    details.append("Opp ID: "+i.ticketid_cm!)
                    details.append("Customer Name: "+i.customername_cm!)
                    details.append("Communication ID: "+i.cid_cm!)
                    details.append("By: "+i.msgfrom_cm!)
                    details.append("To: "+i.msgto_cm!)
                    details.append("Communication: "+i.message_cm!)
                    details.append("Date Time: "+i.datetime_cm!)
                    details.append("Read Flag: "+i.communicationflag_cm!)
                    
                   m_strMsgTo = i.msgto_cm!
                    
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
            let cell=CommunicationdetailsTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            //
            
            
            
            let cornerRadius: CGFloat = 6.0
            
            
            // Configure the cell...
            
            
            
            cell.lblCommunicationDetails.text=details[indexPath.row]
            cell.lblCommunicationDetails.textColor = (details[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
            
            
            return cell
            
            
        }
        @IBAction func onclickReply(_ sender: Any) {
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "communicationreply") as!
            CommunicationReplyActivityViewController
            
            viewcontroller.oid = oid
            viewcontroller.cid = cid
            viewcontroller.m_strMsgTo = m_strMsgTo
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
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
