//
//  SettingTableViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 09/10/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
struct Headline {
    
    //    var id : Int
    var title : String
    
    var image : String
    
}
class SettingTableViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //
    var headlines = [
        Headline( title: "MY AVAILABILITY", image: "Routingactivitymenuicon"),
        Headline( title: "LEAD", image: "Routingactivitymenuicon"),
        Headline( title: "OPPORTUNITY", image: "Routingactivitymenuicon"),
        Headline( title: "MEETING TRACKER",image: "Routingactivitymenuicon"),
        Headline( title: "DAILY ACTIVITY", image: "Routingactivitymenuicon"),
        Headline( title: "COMMUNICATION", image: "Routingactivitymenuicon"),
        Headline( title: "TO DO", image: "Routingactivitymenuicon"),
        Headline( title: "CLAIM MANAGEMENT", image: "Routingactivitymenuicon"),
        Headline( title: "NEWS ALERT", image: "Routingactivitymenuicon"),
        Headline( title: "HELP", image: "Routingactivitymenuicon"),
        Headline(title: "TARGET WISE DASHBOARD", image: "Routingactivitymenuicon"),
        Headline( title: "SETTING", image: "Routingactivitymenuicon"),
        Headline( title: "CALENDER", image: "Routingactivitymenuicon"),
        Headline( title: "AUTO CLAIM SHEET", image: "Routingactivitymenuicon")
    ]
    
    
    @IBOutlet weak var settingtableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        settingtableview.delegate = self
        settingtableview.dataSource = self
        
        //        self.settingtableview.isEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingtableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let headline = headlines[indexPath.row]
        cell.textLabel?.text = headline.title
        //        cell.detailTextLabel?.text = headline.text
        //        cell.imageView?.image = UIImage(named: headline.image)
        
        return cell
    }
    //
    //     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //            return .none
    //        }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.headlines[sourceIndexPath.row]
        headlines.remove(at: sourceIndexPath.row)
        headlines.insert(movedObject, at: destinationIndexPath.row)
        debugPrint("\(sourceIndexPath.row) => \(destinationIndexPath.row)")
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    
    @IBAction func OnclickEdit(_ sender: Any) {
        self.settingtableview.isEditing = true
        
    }
    
    @IBAction func OnclickSave(_ sender: Any) {
    }
    
    
}
