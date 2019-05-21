//
//  CoreDataHandlerforCommunicationview.swift
//  UnoPointSLM
//
//  Created by Amit A on 13/03/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CoreDataHandlerforCommunicationview: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    class func saveObject(CID:String,OID:String,MsgFrom:String,
                          MsgTo:String,Message:String,
                          Datetime:String,Communicationflag:String,
                          CustomerName:String
                          ) {
        
        
        
        
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            //        let context=getContext()
            let entity=NSEntityDescription.entity(forEntityName: "Communicationviewmaster_cm", in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            manageobject.setValue(CID,forKey: "cid_cm")
            manageobject.setValue(OID,forKey: "ticketid_cm")
            
            manageobject.setValue(MsgFrom,forKey: "msgfrom_cm")
            
            manageobject.setValue(MsgTo,forKey: "msgto_cm")
            manageobject.setValue(Message,forKey: "message_cm")
            manageobject.setValue(Datetime,forKey: "datetime_cm")
            manageobject.setValue(Communicationflag,forKey: "communicationflag_cm")
            manageobject.setValue(CustomerName,forKey: "customername_cm")
            
            
            
            
            
            do{
                try context.save()
                //             return true
                
            }catch{
                //            return false
            }
        }
        //         return true
        
    }
    class func fetchData() -> [Communicationviewmaster_cm]? {
        let context = getContext()
        var CommunicationDetails:[Communicationviewmaster_cm]? = nil
        
        do{
            
            CommunicationDetails = try context.fetch(Communicationviewmaster_cm.fetchRequest())
            return CommunicationDetails
            
        }catch{
            return CommunicationDetails
            
        }
        
    }
    
    class func cleardata() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Communicationviewmaster_cm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func filterDataOIDwise(OID:String) -> [Communicationviewmaster_cm]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Communicationviewmaster_cm> = Communicationviewmaster_cm.fetchRequest()
        var communicationdetailsoidwise:[Communicationviewmaster_cm]? = nil
        
        let predicate = NSPredicate(format: "ticketid_cm contains[c] %@", OID)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            communicationdetailsoidwise = try context.fetch(fetchrequest)
            return communicationdetailsoidwise
            
        }catch{
            return communicationdetailsoidwise
        }
    }
    class func filterDatamsgtowise(msgto:String) -> [Communicationviewmaster_cm]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Communicationviewmaster_cm> = Communicationviewmaster_cm.fetchRequest()
        var communicationmsgtoewise:[Communicationviewmaster_cm]? = nil
        
        let predicate = NSPredicate(format: "msgto_cm contains[c] %@", msgto)
       
        fetchrequest.predicate = predicate
        do{
            communicationmsgtoewise = try context.fetch(fetchrequest)
            return communicationmsgtoewise
            
        }catch{
            return communicationmsgtoewise
        }
    }
    class func filterDatamsgfromwise(msgfrom:String) -> [Communicationviewmaster_cm]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Communicationviewmaster_cm> = Communicationviewmaster_cm.fetchRequest()
        var communicationmsgfromwise:[Communicationviewmaster_cm]? = nil
        
        let predicate = NSPredicate(format: "msgfrom_cm contains[c] %@", msgfrom)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            communicationmsgfromwise = try context.fetch(fetchrequest)
            return communicationmsgfromwise
            
        }catch{
            return communicationmsgfromwise
        }
    }
    class func filterData(oid:String,cid:String) -> [Communicationviewmaster_cm]?{
        let context=getContext()
        
        
        let fetchrequest : NSFetchRequest<Communicationviewmaster_cm> = Communicationviewmaster_cm.fetchRequest()
        var communicationdetails:[Communicationviewmaster_cm]? = nil
        
        let predicate = NSPredicate(format: "ticketid_cm contains[c] %@ And cid_cm contains[c] %@", oid,cid)
        //        [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR ssid contains[cd] %@", query, query];
        fetchrequest.predicate = predicate
        do{
            communicationdetails = try context.fetch(fetchrequest)
            return communicationdetails
            
        }catch{
            return communicationdetails
        }
}
}
