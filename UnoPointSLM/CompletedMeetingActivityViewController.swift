//
//  CompletedMeetingActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 18/02/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

    import UIKit
    
    class CompletedMeetingActivityViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
        
        var completedmeeting:[Completedmeetingview_cmv]? = nil
        var currentItem = ""
        @IBOutlet weak var CompletedmeetingTableView: UITableView!
        
        var m_stripname:String?
        var m_strappversion:String?
        var m_strenggimeino:String?
        var refreshControl:UIRefreshControl = UIRefreshControl()
        
        var oid = [String]()
        var executivename = [String]()
        var customername = [String]()
        var meetingdate = [String]()
        var ordervalue = [String]()
        
        var filterexecutivename = [String]()
        var filtercustomername = [String]()
        var filteroid = [String]()
        
        var picker : UIPickerView!
        var activeTextField = 0
        var activeTF : UITextField!
        var activeValue = ""
        
        // text fields
        @IBOutlet var tf_A: UITextField!
        @IBOutlet var tf_B: UITextField!
        @IBOutlet var tf_C: UITextField!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let preferences = UserDefaults.standard
            
            if preferences.object(forKey: "CustomerUrl") != nil{
                
                m_stripname = preferences.object(forKey: "CustomerUrl") as! String
                m_strappversion = preferences.object(forKey: "Customerappver") as! String
                m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
            }
            
            
            // Refresh Table view
            
            refreshControl.tintColor = UIColor.orange
            refreshControl.backgroundColor = UIColor.darkGray
            //        refreshControl.attributedTitle = NSAttributedString(string: "Please Wait While Refreshing Details", attributes: [NSForegroundColorAttributeName : refreshControl.tintColor]?)
            refreshControl.attributedTitle = NSAttributedString(string: "Please Wait While Refreshing Details")
            refreshControl.addTarget(self, action: #selector(RefreshData), for: UIControlEvents.valueChanged)
            if #available(iOS 10.0,*){
                CompletedmeetingTableView.refreshControl = refreshControl
            }else{
                CompletedmeetingTableView.addSubview(refreshControl)
            }
            
            
            
            downloadJson {
                self.BuildTable()
            }
            
            CompletedmeetingTableView.delegate=self
            CompletedmeetingTableView.dataSource=self
            
            
            // Do any additional setup after loading the view.
        }
        func BuildTable(){
            DispatchQueue.main.async {
                self.completedmeeting=CoreDataHandlerforCompletedmeetingview.fetchData()
                
                self.oid = [String]()
                self.executivename = [String]()
                self.customername = [String]()
                self.meetingdate = [String]()
                self.ordervalue = [String]()
                
                
                self.filterexecutivename.append("Select")
                self.filtercustomername.append("Select")
                self.filteroid.append("Select")
                
                for i in self.completedmeeting!{
                    self.oid.append(i.ticketid_cmv!)
                    self.executivename.append(i.executivename_cmv!)
                    self.customername.append(i.custname_cmv!)
                    self.meetingdate.append(i.meetingdate_cmv!)
                    self.ordervalue.append(i.ordervalue_cmv!)
                    
                    self.filterexecutivename.append(i.executivename_cmv!)
                    self.filtercustomername.append(i.custname_cmv!)
                    self.filteroid.append(i.ticketid_cmv!)
                    
                    
                    
                }
                
                // Call the method to dedupe the string array.
                
                if(self.filterexecutivename.count>0){
                    let dedupeexecutivename = self.removeDuplicates(array: self.filterexecutivename)
                    self.filterexecutivename = [String]()
                    
                    
                    self.filterexecutivename = dedupeexecutivename
                }
                
                if(self.filtercustomername.count>0){
                    let dedupecustName = self.removeDuplicates(array: self.filtercustomername)
                    self.filtercustomername = [String]()
                    
                    
                    self.filtercustomername = dedupecustName
                    
                }
                if(self.filteroid.count>0){
                    let dedupeoid = self.removeDuplicates(array: self.filteroid)
                    self.filteroid = [String]()
                    
                    
                    self.filteroid = dedupeoid
                    
                }
                
                
                
                self.CompletedmeetingTableView.reloadData()
            }
            
            
            
        }
        func removeDuplicates(array: [String]) -> [String] {
            var encountered = Set<String>()
            var result: [String] = []
            for value in array {
                if encountered.contains(value) {
                    // Do not add a duplicate element.
                }
                else {
                    // Add value to the set.
                    encountered.insert(value)
                    // ... Append the value.
                    result.append(value)
                }
            }
            return result
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.y
            if offset < -150{
                refreshControl.attributedTitle = NSAttributedString(string: "Please Wait While Refreshing Details")
            }else{
                refreshControl.attributedTitle = NSAttributedString(string: "Please Wait While Refreshing Details")
            }
        }
        
        @objc func RefreshData(){
            LoadingIndicatorView.show("Please Wait while Fetching Ticket...")
            downloadJson {
                DispatchQueue.main.async {
                    self.BuildTable()
                    LoadingIndicatorView.hide()
                    self.refreshControl.endRefreshing()
                }
            }
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return oid.count
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell=CompletedmeetingTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            
            
            // Configure the cell...
            
            let cornerRadius: CGFloat = 6.0
            cell.uiviewcompletedgmeeting.layer.cornerRadius = cornerRadius
            
            cell.uiviewcompletedgmeeting.layer.masksToBounds = true
           
            
            cell.lblcompletemeetingoppid.text="Opp ID:"+oid[indexPath.row]
            cell.lblcompletemeetingoppid.textColor = (oid[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
            
            cell.lblcompletemeetingexecutivenames.text="Executive Name:"+executivename[indexPath.row]
            cell.lblcompletemeetingexecutivenames.textColor = (executivename[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
            
            cell.lblcompletemeetingcustomernames.text="Customer Name:"+customername[indexPath.row]
            cell.lblcompletemeetingcustomernames.textColor = (customername[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
            
            cell.lblcompletemeetingmeetingdate.text="Meeting Date:"+meetingdate[indexPath.row]
            cell.lblcompletemeetingmeetingdate.textColor = (meetingdate[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
            
            cell.lblcompletemeetingordervalue.text="Order Value:"+ordervalue[indexPath.row]
            cell.lblcompletemeetingordervalue.textColor = (ordervalue[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
            
            
            
            
            
            
            
            return cell
            
            
            
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "Upcomingmeetingdetails") as!
            UpcomingmeetingdetailsctivityViewController
            
            viewcontroller.oid = oid[(CompletedmeetingTableView.indexPathForSelectedRow?.row)!]
            viewcontroller.executivename = executivename[(CompletedmeetingTableView.indexPathForSelectedRow?.row)!]
            viewcontroller.customername = customername[(CompletedmeetingTableView.indexPathForSelectedRow?.row)!]
            
             viewcontroller.action = "Completed"
            
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            
            //         performSegue(withIdentifier: "showDetails", sender: self)
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func downloadJson(completed: @escaping () -> ()) {
            if let url = NSURL(string: m_stripname!+"/DeviceMeetingManager.do") {
                //                let request = NSMutableURLRequest( url: url as URL,cac)
                var request = NSMutableURLRequest.init(url: url as URL, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 15)
                request.httpMethod = "POST"
                let postString : String = "action=MeetingCompleted&imei="+m_strenggimeino!+"&ver="+m_strappversion!
                
                print(url)
                print(postString)
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    
                    if  error != nil{
                        completed()
                    }
                    else{
                        do{
                            CoreDataHandlerforCompletedmeetingview.cleardata()
                            
                            
                            if let data = data,
                                
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                                if let results = json["results"] as? [[String: Any]]  {
                                    for case let blog in (json["results"] as? [[String: Any]])! {
                                        //
                                        
                                        if let OID = blog["OID"] as? String {
                                            //                                                    self.companyName.append(name)
                                            if   let CustomerName = blog["Customer Name"] as? String{
//                                            let SchduleDate = blog["Schedule Date"] as? String
                                            
                                            let MeetingDate = blog["Meeting Date"] as? String
                                            let MeetingStartTime = blog["Meeting StartTime"] as? String
                                            let MeetingEndTime = blog["Meeting EndTime"] as? String
                                            let MeetingDuration = blog["Meeting Duration"] as? String
                                            let MeetingComment = blog["Meeting Comment"] as? String
                                            let Details = blog["Details"] as? String
                                            
                                            let Ordervalue = blog["Order value"] as? String
                                            let ActionReqiured = blog["Action Reqiured"] as? String
                                            let MeetingPlace = blog["Meeting Place"] as? String
                                             let Address = blog["Address"] as? String
                                            let ExecutiveName = blog["Executive Name"] as? String
                                            
                                            CoreDataHandlerforCompletedmeetingview.saveObject(TicketID: OID, CustomerName: CustomerName, Meetingdate: MeetingDate!, Meetingstarttime: MeetingStartTime!, Meetingendtime: MeetingEndTime!, Meetingduration: MeetingDuration!, Meetingcomment: MeetingComment!, Details: Details!, Ordervalue: Ordervalue!, Actionrequired: ActionReqiured!, Meetingplace: MeetingPlace!, Address: Address!, executivename: ExecutiveName!)
                                            
                                            
                                            
                                            //                                        DispatchQueue.main.async {
                                            
                                                                                    }
                                        
                                            
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                            
                            
                            
                            //                        }
                            
                            
                            
                            
                            
                            
                            
                            //                                    DispatchQueue.main.async {
                            //
                            //                                         self.BuildTable()
                            
                            
                            completed()
                            //                                    }
                        }catch{
                            print("Json Error")
                        }
                    }
                    
                    
                }
                task.resume()
            }
        }
        
        @IBAction func onclickSearchFilter(_ sender: Any) {
            showInputDialog()
        }
        
        func showInputDialog() {
            //Creating UIAlertController and
            //Setting title and message for the alert dialog
            let alertController = UIAlertController(title: "UnoPoint", message: "Enter Details", preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                
                //getting the input values from user
                let executivename = alertController.textFields?[0].text
                
                let customername = alertController.textFields?[1].text
                let oid = alertController.textFields?[2].text
                
                
                
                self.oid = [String]()
                self.customername = [String]()
                self.executivename = [String]()
                if((executivename == ""  || executivename == "Select") && (customername == ""  || customername == "Select") && (oid == ""  || oid == "Select")){
                    let alertController = UIAlertController(title: "UnoPoint", message:
                        "Please select Executive Name or Customer Name or Opportunity ID For Searching", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                if((executivename != ""  && executivename != "Select") && (customername == ""  || customername == "Select") && (oid == ""  || oid == "Select")){
                    self.completedmeeting = CoreDataHandlerforCompletedmeetingview.filterDataExecutivewise(executivename: executivename!)
                }
                if((executivename == ""  || executivename == "Select") && (customername != ""  && customername != "Select") && (oid == ""  || oid == "Select")){
                    self.completedmeeting=CoreDataHandlerforCompletedmeetingview.filterDataCustNamewise(custname: customername!)
                }
                if((executivename == ""  || executivename == "Select") && (customername == ""  || customername == "Select") && (oid != ""  && oid != "Select")){
                    self.completedmeeting=CoreDataHandlerforCompletedmeetingview.filterDataOidwise(oid: oid!)
                }
                
                self.oid = [String]()
                self.executivename = [String]()
                self.customername = [String]()
                self.meetingdate = [String]()
                self.ordervalue = [String]()
                
                for i in self.completedmeeting!{
                    self.oid.append(i.ticketid_cmv!)
                    self.executivename.append(i.executivename_cmv!)
                    self.customername.append(i.custname_cmv!)
                    self.meetingdate.append(i.meetingdate_cmv!)
                    self.ordervalue.append(i.ordervalue_cmv!)
                }
                
                self.CompletedmeetingTableView.reloadData()
                
                
            }
            
            //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            //adding textfields to our dialog box
            alertController.addTextField { (textField) in
                self.tf_A = textField
                textField.placeholder = "Select Executive Name:"
                textField.delegate = self
            }
            
            alertController.addTextField { (textField) in
                self.tf_B = textField
                textField.placeholder = "Select Customer Name :"
                textField.delegate = self
            }
            alertController.addTextField { (textField) in
                self.tf_C = textField
                textField.placeholder = "Select Opportunity ID :"
                textField.delegate = self
            }
            
            
            //adding the action to dialogbox
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
        }
        // number of components in picekr view
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        // return number of elements in picker view
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            // get number of elements in each pickerview
            switch activeTextField {
            case 1:
                return filterexecutivename.count
            case 2:
                return filtercustomername.count
            case 3:
                return filteroid.count
                
            default:
                return 0
            }
        }
        // return "content" for picker view
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            // return correct content for picekr view
            switch activeTextField {
            case 1:
                return filterexecutivename[row]
            case 2:
                return filtercustomername[row]
            case 3:
                return filteroid[row]
                
                
            default:
                return ""
            }
        }
        // get currect value for picker view
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // set currect active value based on picker view
            switch activeTextField {
            case 1:
                activeValue = filterexecutivename[row]
            case 2:
                activeValue = filtercustomername[row]
            case 3:
                activeValue = filteroid[row]
                
            default:
                activeValue = ""
            }
        }
        // start editing text field
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // set up correct active textField (no)
            switch textField {
            case tf_A:
                activeTextField = 1
            case tf_B:
                activeTextField = 2
            case tf_C:
                activeTextField = 3
                
            default:
                activeTextField = 0
            }
            // set active Text Field
            activeTF = textField
            self.pickUpValue(textField: textField)
        }
        // show picker view
        func pickUpValue(textField: UITextField) {
            // create frame and size of picker view
            picker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
            // deletates
            picker.delegate = self
            picker.dataSource = self
            // if there is a value in current text field, try to find it existing list
            if let currentValue = textField.text {
                var row : Int?
                // look in correct array
                switch activeTextField {
                case 1:
                    row = filterexecutivename.index(of: currentValue)
                case 2:
                    row = filtercustomername.index(of: currentValue)
                case 3:
                    row = filteroid.index(of: currentValue)
                    
                default:
                    row = nil
                }
                // we got it, let's set select it
                if row != nil {
                    picker.selectRow(row!, inComponent: 0, animated: true)
                }
            }
            picker.backgroundColor = UIColor.white
            textField.inputView = self.picker
            // toolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.barTintColor = UIColor.darkGray
            toolBar.sizeToFit()
            // buttons for toolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
        }
        // done
        @objc func doneClick() {
            activeTF.text = activeValue
            activeTF.resignFirstResponder()
        }
        // cancel
        @objc func cancelClick() {
            activeTF.resignFirstResponder()
        }
        
        
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}
