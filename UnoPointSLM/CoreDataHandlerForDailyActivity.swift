//
//  CoreDataHandlerForDailyActivity.swift
//  UnoPointSLM
//
//  Created by Amit A on 07/03/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandlerForDailyActivity: NSObject {
    private class func getContext() -> NSManagedObjectContext{
        //        DispatchQueue.main.async {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return
            appDelegate.persistentContainer.viewContext
        //        }
    }
    
    class func saveObject(typeID:String,typeValue:String,tablename:String,typeextraid:String,typeextravalue:String) {
        
        DispatchQueue.main.async {
            
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            let  context = appDelegate.persistentContainer.viewContext
            
            
            
            let entity=NSEntityDescription.entity(forEntityName: tablename, in: context)
            let manageobject=NSManagedObject(entity:entity!,insertInto: context)
            if(tablename == "Incidentmaster"){
                manageobject.setValue(typeID,forKey: "typeID")
                manageobject.setValue(typeValue,forKey: "typeValue")
               
                
            }else{
                
                manageobject.setValue(typeID,forKey: "typeID")
                manageobject.setValue(typeValue,forKey: "typeValue")
            }
            
            
            do{
                try context.save()
                
                
            }catch{
                
            }
        }
        
    }
    
    class func fetchObjectFromCustomermst() -> [Customermst_cm]? {
        let context = getContext()
        var customer:[Customermst_cm]? = nil
        
        do{
            
            customer = try context.fetch(Customermst_cm.fetchRequest())
            return customer
            
        }catch{
            return customer
            
        }
        
    }
    
    class func cleardataFormCustomermst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Customermst_cm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    class func fetchObjectFromIncidentmst() -> [Incidentmaster_im]? {
        let context = getContext()
        var incidentid:[Incidentmaster_im]? = nil
        
        do{
            
            incidentid = try context.fetch(Incidentmaster_im.fetchRequest())
            return incidentid
            
        }catch{
            return incidentid
            
        }
        
    }
    class func cleardataFormIncidentmst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Incidentmaster_im.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    
}
