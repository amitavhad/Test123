//
//  CoreDataHandlerforCompletedmeetingview.swift
//  UnoPointSLM
//
//  Created by Amit A on 18/02/19.
//  Copyright © 2019 Amit A. All rights reserved.
//


import UIKit
import CoreData
import Foundation

class CoreDataHandlerforCompletedmeetingview: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    class func saveObject(TicketID:String,CustomerName:String,Meetingdate:String,
                          Meetingstarttime:String,Meetingendtime:String,
                          Meetingduration:String,Meetingcomment:String,
                          Details:String,
                          Ordervalue:String,
                          Actionrequired:String,
                          Meetingplace:String,
                          Address:String,
                          executivename:String) {
        
        
        
        
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            //        let context=getContext()
            let entity=NSEntityDescription.entity(forEntityName: "Completedmeetingview_cmv", in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            manageobject.setValue(TicketID,forKey: "ticketid_cmv")
            manageobject.setValue(CustomerName,forKey: "custname_cmv")
            
            manageobject.setValue(executivename,forKey: "executivename_cmv")
            
            manageobject.setValue(Meetingdate,forKey: "meetingdate_cmv")
            manageobject.setValue(Meetingstarttime,forKey: "meetingstarttime_cmv")
            manageobject.setValue(Meetingendtime,forKey: "meetingendtime_cmv")
             manageobject.setValue(Meetingduration,forKey: "meetingduration_cmv")
             manageobject.setValue(Meetingcomment,forKey: "meetingcomment_cmv")
            
            
            manageobject.setValue(Details,forKey: "details_cmv")
            manageobject.setValue(Ordervalue,forKey: "ordervalue_cmv")
            
            manageobject.setValue(Actionrequired,forKey: "actionreqiured_cmv")
            manageobject.setValue(Meetingplace,forKey: "meetingplace_cmv")
            
            manageobject.setValue(Address,forKey: "address_cmv")
            
            
            do{
                try context.save()
                //             return true
                
            }catch{
                //            return false
            }
        }
        //         return true
        
    }
    class func fetchData() -> [Completedmeetingview_cmv]? {
        let context = getContext()
        var Completedmeeting:[Completedmeetingview_cmv]? = nil
        
        do{
            
            Completedmeeting = try context.fetch(Completedmeetingview_cmv.fetchRequest())
            return Completedmeeting
            
        }catch{
            return Completedmeeting
            
        }
        
    }
    
    class func cleardata() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Completedmeetingview_cmv.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func filterDataExecutivewise(executivename:String) -> [Completedmeetingview_cmv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Completedmeetingview_cmv> = Completedmeetingview_cmv.fetchRequest()
        var completedmeetingexecutivewise:[Completedmeetingview_cmv]? = nil
        
        let predicate = NSPredicate(format: "executivename_cmv contains[c] %@", executivename)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            completedmeetingexecutivewise = try context.fetch(fetchrequest)
            return completedmeetingexecutivewise
            
        }catch{
            return completedmeetingexecutivewise
        }
    }
    class func filterDataCustNamewise(custname:String) -> [Completedmeetingview_cmv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Completedmeetingview_cmv> = Completedmeetingview_cmv.fetchRequest()
        var completedmeetingexecutivewise:[Completedmeetingview_cmv]? = nil
        
        let predicate = NSPredicate(format: "custname_cmv contains[c] %@", custname)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            completedmeetingexecutivewise = try context.fetch(fetchrequest)
            return completedmeetingexecutivewise
            
        }catch{
            return completedmeetingexecutivewise
        }
    }
    class func filterDataOidwise(oid:String) -> [Completedmeetingview_cmv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Completedmeetingview_cmv> = Completedmeetingview_cmv.fetchRequest()
        var completedmeetingexecutivewise:[Completedmeetingview_cmv]? = nil
        
        let predicate = NSPredicate(format: "ticketid_cmv contains[c] %@", oid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            completedmeetingexecutivewise = try context.fetch(fetchrequest)
            return completedmeetingexecutivewise
            
        }catch{
            return completedmeetingexecutivewise
        }
    }
    class func filterData(oid:String,executivename:String,custname:String) -> [Completedmeetingview_cmv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Completedmeetingview_cmv> = Completedmeetingview_cmv.fetchRequest()
        var completeddetails:[Completedmeetingview_cmv]? = nil
        
        let predicate = NSPredicate(format: "ticketid_cmv contains[c] %@", oid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            completeddetails = try context.fetch(fetchrequest)
            return completeddetails
            
        }catch{
            return completeddetails
        }
    }
}

