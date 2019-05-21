
//
//  MenuTableViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 09/10/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit

class MenuTableViewController: UITableViewController {
    //    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    var menuItems = ["MY AVAILABILITY", "LEAD", "OPPORTUNITY", "MEETING TRACKER", "DAILY ACTIVITY","COMMUNICATION","TO DO","CLAIM MANAGEMENT","NEWS ALERT","HELP","TARGET WISE DASHBOARD","SETTING","CALENDER","AUTO CLAIM SHEET"]
    var currentItem = ""
    var arrayofImages = [ #imageLiteral(resourceName: "availability"), #imageLiteral(resourceName: "lead"), #imageLiteral(resourceName: "opportunity"), #imageLiteral(resourceName: "meetingtracker"), #imageLiteral(resourceName: "Dailyactivity"), #imageLiteral(resourceName: "communication") ,#imageLiteral(resourceName: "todo"), #imageLiteral(resourceName: "claim"), #imageLiteral(resourceName: "newalert"), #imageLiteral(resourceName: "help"), #imageLiteral(resourceName: "targetwisedashboard"), #imageLiteral(resourceName: "setting"), #imageLiteral(resourceName: "Dailyactivity"), #imageLiteral(resourceName: "claim")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        
        
        let cornerRadius: CGFloat = 6.0
        cell.viewcell.layer.cornerRadius = cornerRadius
        
        cell.viewcell.layer.masksToBounds = true
        
        // Configure the cell...
        
        cell.cellimage.image = arrayofImages[indexPath.row]
        
        cell.titleLabel.text = menuItems[indexPath.row]
        cell.titleLabel.textColor = (menuItems[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = menuItems[indexPath.row]
        if(name == "HELP"){
            let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
            secondController.lblaction = "Help"
            self.navigationController?.pushViewController(secondController, animated: true)
        }else
            
            if(name == "TARGET WISE DASHBOARD"){
                let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
                secondController.lblaction = "MDTargetWiseDashboard"
                self.navigationController?.pushViewController(secondController, animated: true)
            }else
                
                if(name == "CALENDER"){
                    let  secondController = storyboard?.instantiateViewController(withIdentifier: "webview") as! WebViewController
                    secondController.lblaction = "MDView"
                    self.navigationController?.pushViewController(secondController, animated: true)
                }
                else
                    
                    if(name == "DAILY ACTIVITY"){
                        let  secondController = storyboard?.instantiateViewController(withIdentifier: "enggdailyactivity") as! EnggDailyActivityViewController
                       
                        self.navigationController?.pushViewController(secondController, animated: true)
                    }
                    else
                        
                        if(name == "COMMUNICATION"){
                            let  secondController = storyboard?.instantiateViewController(withIdentifier: "communication") as! CommunicationViewActivityController
                            
                            self.navigationController?.pushViewController(secondController, animated: true)
                        }
                    
                else{
                    let  secondController = storyboard?.instantiateViewController(withIdentifier: "showsubmenu") as! ModalViewController
                    secondController.m_strMainmeuname = name
                    self.navigationController?.pushViewController(secondController, animated: true)
        }
        
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        super.prepare(for: segue, sender: sender)
    //
    //        if let indexPath = tableView.indexPathForSelectedRow{
    //            let selectedRow = indexPath.row
    //            let detailVC = menuItems[indexPath.row]
    //            print(detailVC)
    //            let preferences = UserDefaults.standard
    //            // store string value
    //            if(detailVC == "MY AVAILABILITY"){
    //            preferences.set("MY AVAILABILITY", forKey: "submenu")
    //
    //                        //  Save to disk
    //                        let didSave = preferences.synchronize()
    //
    //             }else if(detailVC == "LEAD"){
    //             preferences.set("LEAD", forKey: "submenu")
    //
    //                    //  Save to disk
    //                   let didSave = preferences.synchronize()
    //
    //            }else if(detailVC == "OPPORTUNITY"){
    //                preferences.set("OPPORTUNITY", forKey: "submenu")
    //
    //                //  Save to disk
    //                let didSave = preferences.synchronize()
    //
    //            }else if(detailVC == "SETTING")
    //            {
    //                preferences.set("SETTING", forKey: "submenu")
    //
    //                //  Save to disk
    //                let didSave = preferences.synchronize()
    //            }else{
    //                preferences.set("", forKey: "submenu")
    //
    //                //  Save to disk
    //                let didSave = preferences.synchronize()
    //            }
    //
    //                        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
    //
    ////                        segue.destination.modalPresentationStyle = .custom
    //                        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
    ////                    }else{
    ////                        return
    ////            }
    //        }
    //
    //
    //    }
    
    
    
}
