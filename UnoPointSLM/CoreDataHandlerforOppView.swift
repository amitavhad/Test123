//
//  CoreDataHandlerforOppView.swift
//  UnoPointSLM
//
//  Created by Amit A on 26/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreData
import Foundation





class CoreDataHandlerforOppView: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    
    
    
    
    
    
    
    
    
    
    class func saveObject(oid:String,CustomerName:String,ProgressName:String,
                          ExternalProgress:String,
                          Category:String,
                          Status:String,
                          IncidentAge:String,
                          DateTime:String,
                          AssignedDateTime:String,
                          KSYSSLA:String,
                          HCILSLA:String,
                          ScheduleDateTime:String,
                          OrderValue:String,
                          CustomerAddress:String,
                          EngineerName:String,
                          EngineerContactNo:String,
                          CustomerContact1:String,
                          CustomerContact2:String,
                          CreatedBy:String,
                          LeadID:String,
                          Product_Price_Approval_Status:String,
                          CustomerEmailID1:String,
                          CustomerContactName2:String,
                          CustomerEmailID2:String,
                          CustomerContactNo2:String,
                          CustomerTypeId:String,
                          OTP:String) {
        
        
        
        
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            //        let context=getContext()
            let entity=NSEntityDescription.entity(forEntityName: "Ticketview_tv", in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            
            
            
            
            
            
            
            
        
            
            
            manageobject.setValue(oid,forKey: "ticketid_tv")
            manageobject.setValue(CustomerName,forKey: "panelid_tv")
            
            manageobject.setValue(LeadID,forKey: "leadid_tv")
            manageobject.setValue(EngineerName,forKey: "engineername_tv")
            manageobject.setValue(ProgressName,forKey: "progressname_tv")
            
            
            manageobject.setValue(ExternalProgress,forKey: "externalprogressname_tv")
            manageobject.setValue(Category,forKey: "category_tv")
            
            manageobject.setValue(Status,forKey: "status_tv")
            manageobject.setValue(CustomerAddress,forKey: "customeraddress_tv")
            
            manageobject.setValue(EngineerContactNo,forKey: "engineercontactno_tv")
            manageobject.setValue(IncidentAge,forKey: "incidentage_tv")
        
            manageobject.setValue(KSYSSLA,forKey: "ksyssla_tv")
            manageobject.setValue(HCILSLA,forKey: "hcilsla_tv")
            manageobject.setValue(ScheduleDateTime,forKey: "etadatetime_tv")
            manageobject.setValue(OrderValue,forKey: "atadatetime_tv")
            manageobject.setValue(CustomerContact1,forKey: "afl1_tv")
            manageobject.setValue(CustomerContact2,forKey: "afl2_tv")
            manageobject.setValue(CustomerEmailID1,forKey: "emailid1_tv")
            manageobject.setValue(CustomerContactName2,forKey: "customername2_tv")
            manageobject.setValue(CustomerEmailID2,forKey: "customeremailid2_tv")
            manageobject.setValue(CustomerContactNo2,forKey: "customercontactno2_tv")
            manageobject.setValue(CreatedBy,forKey: "createdby_tv")
            manageobject.setValue(Product_Price_Approval_Status,forKey: "productpriceapprovalstatus_tv")
            manageobject.setValue(CustomerTypeId,forKey: "customertypeid_tv")
            manageobject.setValue(OTP,forKey: "customerotp_tv")

            
            
            
            
            
            
            
            
            
            do{
                try context.save()
                //             return true
                
            }catch{
                //            return false
            }
        }
        //         return true
        
    }
    class func fetchObject() -> [Ticketview_tv]? {
        let context = getContext()
        var ticket:[Ticketview_tv]? = nil
        
        do{
            
            ticket = try context.fetch(Ticketview_tv.fetchRequest())
            return ticket
            
        }catch{
            return ticket
            
        }
        
    }
    
    class func cleardata() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Ticketview_tv.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    
    
    class func filterData(lid:String) -> [Ticketview_tv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Ticketview_tv> = Ticketview_tv.fetchRequest()
        var ticket:[Ticketview_tv]? = nil
        
        let predicate = NSPredicate(format: "ticketid_tv contains[c] %@", lid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            ticket = try context.fetch(fetchrequest)
            return ticket
            
        }catch{
            return ticket
        }
    }
}
