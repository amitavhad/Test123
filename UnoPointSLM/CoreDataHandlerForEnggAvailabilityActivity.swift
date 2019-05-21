//
//  CoreDataHandlerForEnggAvailabilityActivity.swift
//  UnoPointSLM
//
//  Created by Amit A on 12/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandlerForEnggAvailabilityActivity: NSObject {
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
    
    class func fetchObjectFromENgineerLeaveSummarymst() -> [EngineerLeaveSummarymst_elsm]? {
        let context = getContext()
        var enggsummary:[EngineerLeaveSummarymst_elsm]? = nil
        
        do{
            
            enggsummary = try context.fetch(EngineerLeaveSummarymst_elsm.fetchRequest())
            return enggsummary
            
        }catch{
            return enggsummary
            
        }
        
    }
    
    class func cleardataFormenggsummarymst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: EngineerLeaveSummarymst_elsm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    
    
    class func fetchObjectFromLeavetypemaster() -> [Leavetypemaster_ltm]? {
        let context = getContext()
        var enggsummary:[Leavetypemaster_ltm]? = nil
        
        do{
            
            enggsummary = try context.fetch(Leavetypemaster_ltm.fetchRequest())
            return enggsummary
            
        }catch{
            return enggsummary
            
        }
        
    }
    
    class func cleardataFormLeavTypemst() -> Bool{
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Leavetypemaster_ltm.fetchRequest())
        do{
            try context.execute(delete)
            return true
            
        }catch{
            return false
        }
    }
    
}

