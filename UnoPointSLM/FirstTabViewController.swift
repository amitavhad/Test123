//
//  FirstTabViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 22/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit

class FirstTabViewController: UIViewController, CheckboxDialogViewDelegate {
    var checkboxDialogViewController: CheckboxDialogViewController!
    
    @IBOutlet weak var txtDespositionDesc: UITextField!
    //define typealias-es
    typealias TranslationTuple = (name: String, translated: String)
    typealias TranslationDictionary = [String : String]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("First VC will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("First VC will disappear")
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        // this tuple has translated key because it can use localized values in case app needs to be localized
        var tableData: [TranslationTuple] = []
         var ticket:[Leadview_lv]? = nil
           ticket=CoreDataHandlerforLeadView.fetchObject()
        for i in ticket!{
            tableData.append((name: i.businessunit_lv!, translated: i.businessunit_lv!))
        }
//        let tableData :[(name: String, translated: String)] = [("Angola", "Angole"),
//                                                               ("Croatia", "Croatia"),
//                                                               ("Germany", "Germany"),
//                                                               ("Ireland", "Ireland"),
//                                                               ("Spain", "Spain"),
//                                                               ("United Kingdom", "United Kingdom"),
//                                                                ("United Kingdom", "United Kingdom"),
//                                                                 ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                                  ("United Kingdom", "United Kingdom"),
//                                                               ("Venezuela", "Venezuela")]
        
        
        self.checkboxDialogViewController = CheckboxDialogViewController()
        self.checkboxDialogViewController.titleDialog = "Details"
        self.checkboxDialogViewController.tableData = tableData
//        self.checkboxDialogViewController.defaultValues = [tableData[3]]
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.details
        self.checkboxDialogViewController.delegateDialogTableView = self
        self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogViewController, animated: false, completion: nil)
    }
    
    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
        print(component)
        print(values)
        var m_strDespositionDesc = ""
        var tuple: [TranslationTuple] = []
        for (name, translated) in values {
            if(m_strDespositionDesc == ""){
                m_strDespositionDesc = name
            }else{
                m_strDespositionDesc = m_strDespositionDesc+","+name
            }
            
            print("value getted"+name)
        }
        txtDespositionDesc.text = m_strDespositionDesc
    }
}
