//
//  CoreDataHandlerForEnggActivity.swift
//  UnoPointSLM
//
//  Created by Amit A on 12/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit
import CoreData

class CoreDataHandlerForEnggActivity: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    
    class func saveObject(typeID:String,typeValue:String,tablename:String) {
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            
            let entity=NSEntityDescription.entity(forEntityName: tablename, in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            
            manageobject.setValue(typeID,forKey: "typeID")
            manageobject.setValue(typeValue,forKey: "typeValue")
            
            
            
            do{
                try context.save()
                
                
            }catch{
                
            }
        }
        
    }
    
    
//    class func fetchObjectFromTicketactivitymst() -> [Ticketactivitymst_tam]? {
//        let context = getContext()
//        var ticket:[Ticketactivitymst_tam]? = nil
//
//        do{
//
//            ticket = try context.fetch(Ticketactivitymst_tam.fetchRequest())
//            return ticket
//
//        }catch{
//            return ticket
//
//        }
//
//    }
//
//    class func fetchObjectFromTicketactivityStatusmst() -> [Ticketactivitystatusmst_tasm]? {
//        let context = getContext()
//        var ticketstatus:[Ticketactivitystatusmst_tasm]? = nil
//
//        do{
//
//            ticketstatus = try context.fetch(Ticketactivitystatusmst_tasm.fetchRequest())
//            return ticketstatus
//
//        }catch{
//            return ticketstatus
//
//        }
//
//    }
    
    
//    class func cleardataForTicketActivity() -> Bool{
//        let context = getContext()
//        let delete = NSBatchDeleteRequest(fetchRequest: Ticketactivitymst_tam.fetchRequest())
//        do{
//            try context.execute(delete)
//            return true
//
//        }catch{
//            return false
//        }
//    }
//
//    class func cleardataForTicketActivitystats() -> Bool{
//        let context = getContext()
//        let delete = NSBatchDeleteRequest(fetchRequest: Ticketactivitystatusmst_tasm.fetchRequest())
//        do{
//            try context.execute(delete)
//            return true
//
//        }catch{
//            return false
//        }
//    }
    
    class func fetchObjectFromEarlyOutReasonmst() -> [EarlyOutReasonmst_eorm]? {
        let context = getContext()
        var earlyoutreason:[EarlyOutReasonmst_eorm]? = nil
        
        do{
            
            earlyoutreason = try context.fetch(EarlyOutReasonmst_eorm.fetchRequest())
            return earlyoutreason
            
        }catch{
            return earlyoutreason
            
        }
        
    }
    
    class func cleardataForEarlyReasonmst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: EarlyOutReasonmst_eorm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    
    
    
}

