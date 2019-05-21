//
//  CoreDataHandlerforLeadView.swift
//  UnoPointSLM
//
//  Created by Amit A on 16/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class CoreDataHandlerforLeadView: NSObject {
    
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    class func saveObject(LeadId:String,BusinessUnit:String,LeadSource:String,LeadDate:String,
                          LeadTime:String,Description:String,Detail:String,ProductCategory:String,ProductSubCategory:String,CustomerType:String,CustomerName:String,CustomerAddress:String,State:String,City:String,OrderValue:String,CustomerContactName1:String,CustomerContactNo1:String,Emailid1:String,Designation1:String,CustomerContactName2:String,CustomerContactNo2:String,Emailid2:String,Designation2:String,Status:String,LeadCloseDate:String,LeadCloseTime:String,Disposition:String,DispositionDescription:String,CallBackDate:String,CreatedByExecutive:String,CreatedByRole:String,OpportunityStatus:String,PostalCode:String,LeadType:String,OppurtunityId:String,Remarks1:String,Remarks2:String,ExecutiveName:String,ExecutiveContactNo:String) {
        
        
        
        
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            //        let context=getContext()
            let entity=NSEntityDescription.entity(forEntityName: "Leadview_lv", in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            
            manageobject.setValue(LeadId,forKey: "leadid_lv")
            manageobject.setValue(BusinessUnit,forKey: "businessunit_lv")
            manageobject.setValue(LeadSource,forKey: "leadsource_lv")
            manageobject.setValue(LeadDate,forKey: "leaddate_lv")
            manageobject.setValue(LeadTime,forKey: "leadtime_lv")
            manageobject.setValue(Description,forKey: "description_lv")
            manageobject.setValue(Detail,forKey: "detail_lv")
            manageobject.setValue(ProductCategory,forKey: "productcategory_lv")
            manageobject.setValue(ProductSubCategory,forKey: "productsubcategory_lv")
            manageobject.setValue(CustomerType,forKey: "custtype_lv")
            manageobject.setValue(CustomerName,forKey: "customername_lv")
            manageobject.setValue(CustomerAddress,forKey: "customeraddress_lv")
            manageobject.setValue(State,forKey: "state_lv")
            manageobject.setValue(City,forKey: "city_lv")
            manageobject.setValue(OrderValue,forKey: "ordervalue_lv")
            manageobject.setValue(CustomerContactName1,forKey: "customercontactname1_lv")
            manageobject.setValue(CustomerContactNo1,forKey: "customercontactno1_lv")
            manageobject.setValue(Emailid1,forKey: "emailid1_lv")
            manageobject.setValue(Designation1,forKey: "designation1_lv")
            manageobject.setValue(CustomerContactName2,forKey: "customercontactname2_lv")
            manageobject.setValue(CustomerContactNo2,forKey: "customercontactno2_lv")
            manageobject.setValue(Emailid2,forKey: "emailid2_lv")
            manageobject.setValue(Designation2,forKey: "designation2_lv")
            manageobject.setValue(Status,forKey: "status_lv")
            manageobject.setValue(LeadCloseDate,forKey: "leadclosedate_lv")
            manageobject.setValue(LeadCloseTime,forKey: "leadclosetime_lv")
            manageobject.setValue(Disposition,forKey: "disposition_lv")
            manageobject.setValue(DispositionDescription,forKey: "dispositiondescription_lv")
            manageobject.setValue(CallBackDate,forKey: "callbackdate_lv")
            manageobject.setValue(CreatedByExecutive,forKey: "createdbyexecutive_lv")
            manageobject.setValue(CreatedByRole,forKey: "createdbyrole_lv")
            manageobject.setValue(OpportunityStatus,forKey: "opportunitystatus_lv")
            manageobject.setValue(PostalCode,forKey: "postalcode_lv")
            manageobject.setValue(LeadType,forKey: "leadtype_lv")
            manageobject.setValue(OppurtunityId,forKey: "oppurtunityid_lv")
            manageobject.setValue(Remarks1,forKey: "remarks1_lv")
            manageobject.setValue(Remarks2,forKey: "remarks2_lv")
            manageobject.setValue(ExecutiveName,forKey: "executivename_lv")
            manageobject.setValue(ExecutiveContactNo,forKey: "executivecontactno_lv")
           
            
            
            
            
            
            
            
            
            do{
                try context.save()
                //             return true
                
            }catch{
                //            return false
            }
        }
        //         return true
        
    }
    class func fetchObject() -> [Leadview_lv]? {
        let context = getContext()
        var ticket:[Leadview_lv]? = nil
        
        do{
            
            ticket = try context.fetch(Leadview_lv.fetchRequest())
            return ticket
            
        }catch{
            return ticket
            
        }
        
    }
    
    class func cleardata() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Leadview_lv.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func filterData(lid:String) -> [Leadview_lv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Leadview_lv> = Leadview_lv.fetchRequest()
        var ticket:[Leadview_lv]? = nil
        
        let predicate = NSPredicate(format: "leadid_lv contains[c] %@", lid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            ticket = try context.fetch(fetchrequest)
            return ticket
            
        }catch{
            return ticket
        }
    }
  //for activity header
    class func cleardatafromactivityheader() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Activityheadermaster_ahm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func fetchObjectfromactivityheader() -> [Activityheadermaster_ahm]? {
        let context = getContext()
        var activityheader:[Activityheadermaster_ahm]? = nil
        
        do{
            
            activityheader = try context.fetch(Activityheadermaster_ahm.fetchRequest())
            return activityheader
            
        }catch{
            return activityheader
            
        }
        
    }
    
     //for location master
    
    class func cleardatafromlocationmaster() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Locationmaster_lm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func fetchObjectfromlocationmaster() -> [Locationmaster_lm]? {
        let context = getContext()
        var locationmaster:[Locationmaster_lm]? = nil
        
        do{
            
            locationmaster = try context.fetch(Locationmaster_lm.fetchRequest())
            return locationmaster
            
        }catch{
            return locationmaster
            
        }
        
    }
    
    // for lead close desposition mst
    
    class func cleardatafromleaddespositionmst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Leaddespositionmast_ldm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func fetchObjectfromleaddespositionmst() -> [Leaddespositionmast_ldm]? {
        let context = getContext()
        var leaddesposition:[Leaddespositionmast_ldm]? = nil
        
        do{
            
            leaddesposition = try context.fetch(Leaddespositionmast_ldm.fetchRequest())
            return leaddesposition
            
        }catch{
            return leaddesposition
            
        }
        
    }
    
    // for lead close desposition desc mst
    
    class func cleardatafromleaddespositiondescmst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Leaddespdescmst_lddm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func fetchObjectfromleaddespositiondescmst() -> [Leaddespdescmst_lddm]? {
        let context = getContext()
        var leaddespositiondesc:[Leaddespdescmst_lddm]? = nil
        
        do{
            
            leaddespositiondesc = try context.fetch(Leaddespdescmst_lddm.fetchRequest())
            return leaddespositiondesc
            
        }catch{
            return leaddespositiondesc
            
        }
        
    }
    
}
