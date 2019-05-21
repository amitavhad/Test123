//
//  CoreDataHandlerforUpcomingmeetingview.swift
//  UnoPointSLM
//
//  Created by Amit A on 14/02/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CoreDataHandlerforUpcomingmeetingview: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    class func saveObject(TicketID:String,CustomerName:String,Scheduldedate:String,
                          Scheduldetime:String,
                          Scheduldecomment:String,
                          Details:String,
                          Ordervalue:String,
                          City:String,
                          State:String,
                          Address:String,
                          executivename:String) {
        
        
        
        
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            //        let context=getContext()
            let entity=NSEntityDescription.entity(forEntityName: "Upmeeting_umv", in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            manageobject.setValue(TicketID,forKey: "tickedid_umv")
            manageobject.setValue(CustomerName,forKey: "custname_umv")
            
            manageobject.setValue(Scheduldedate,forKey: "scheduldedate_umv")
            manageobject.setValue(Scheduldetime,forKey: "scheduldetime_umv")
            manageobject.setValue(Scheduldecomment,forKey: "schedulecomment_umv")
            
            
            manageobject.setValue(Details,forKey: "details_umv")
            manageobject.setValue(Ordervalue,forKey: "ordervalue_umv")
            
            manageobject.setValue(City,forKey: "city_umv")
            manageobject.setValue(State,forKey: "state_umv")
            
            manageobject.setValue(Address,forKey: "address_umv")
            manageobject.setValue(executivename,forKey: "executivename_umv")
            
            do{
                try context.save()
                //             return true
                
            }catch{
                //            return false
            }
        }
        //         return true
        
    }
    class func fetchData() -> [Upmeeting_umv]? {
        let context = getContext()
        var Upcomingmeeting:[Upmeeting_umv]? = nil
        
        do{
            
            Upcomingmeeting = try context.fetch(Upmeeting_umv.fetchRequest())
            return Upcomingmeeting
            
        }catch{
            return Upcomingmeeting
            
        }
        
    }
    
    class func cleardata() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Upmeeting_umv.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func filterDataExecutivewise(executivename:String) -> [Upmeeting_umv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Upmeeting_umv> = Upmeeting_umv.fetchRequest()
        var upcomingmeetingexecutivewise:[Upmeeting_umv]? = nil
        
        let predicate = NSPredicate(format: "executivename_umv contains[c] %@", executivename)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            upcomingmeetingexecutivewise = try context.fetch(fetchrequest)
            return upcomingmeetingexecutivewise
            
        }catch{
            return upcomingmeetingexecutivewise
        }
    }
    class func filterDataCustNamewise(custname:String) -> [Upmeeting_umv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Upmeeting_umv> = Upmeeting_umv.fetchRequest()
        var upcomingmeetingexecutivewise:[Upmeeting_umv]? = nil
        
        let predicate = NSPredicate(format: "custname_umv contains[c] %@", custname)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            upcomingmeetingexecutivewise = try context.fetch(fetchrequest)
            return upcomingmeetingexecutivewise
            
        }catch{
            return upcomingmeetingexecutivewise
        }
    }
    class func filterDataOidwise(oid:String) -> [Upmeeting_umv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Upmeeting_umv> = Upmeeting_umv.fetchRequest()
        var upcomingmeetingexecutivewise:[Upmeeting_umv]? = nil
        
        let predicate = NSPredicate(format: "tickedid_umv contains[c] %@", oid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            upcomingmeetingexecutivewise = try context.fetch(fetchrequest)
            return upcomingmeetingexecutivewise
            
        }catch{
            return upcomingmeetingexecutivewise
        }
    }
    class func filterData(oid:String,executivename:String,custname:String) -> [Upmeeting_umv]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Upmeeting_umv> = Upmeeting_umv.fetchRequest()
        var upcomingdetails:[Upmeeting_umv]? = nil
        
        let predicate = NSPredicate(format: "tickedid_umv contains[c] %@", oid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            upcomingdetails = try context.fetch(fetchrequest)
            return upcomingdetails
            
        }catch{
            return upcomingdetails
        }
    }
}
