//
//  UpcomingMeetingActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 13/02/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit

class UpcomingMeetingActivityViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
    
    var upcomingmeeing:[Upmeeting_umv]? = nil
    var currentItem = ""
    @IBOutlet weak var UpcomingmeetingTableView: UITableView!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var oid = [String]()
    var executivename = [String]()
    var customername = [String]()
    var scheduledate = [String]()
    var scheduletime = [String]()
    
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
            UpcomingmeetingTableView.refreshControl = refreshControl
        }else{
            UpcomingmeetingTableView.addSubview(refreshControl)
        }
        
        
        
        downloadJson {
            self.BuildTable()
        }
        
        UpcomingmeetingTableView.delegate=self
        UpcomingmeetingTableView.dataSource=self
        
        
        // Do any additional setup after loading the view.
    }
    func BuildTable(){
        DispatchQueue.main.async {
            self.upcomingmeeing=CoreDataHandlerforUpcomingmeetingview.fetchData()
            
            self.oid = [String]()
            self.executivename = [String]()
            self.customername = [String]()
            self.scheduledate = [String]()
            self.scheduletime = [String]()
            
            
            self.filterexecutivename.append("Select")
            self.filtercustomername.append("Select")
            self.filteroid.append("Select")
            
            for i in self.upcomingmeeing!{
                self.oid.append(i.tickedid_umv!)
                self.executivename.append(i.executivename_umv!)
                self.customername.append(i.custname_umv!)
                self.scheduledate.append(i.scheduldedate_umv!)
                self.scheduletime.append(i.scheduldetime_umv!)
                
                self.filterexecutivename.append(i.executivename_umv!)
                self.filtercustomername.append(i.custname_umv!)
                self.filteroid.append(i.tickedid_umv!)
                
                
                
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
            
            
            
            self.UpcomingmeetingTableView.reloadData()
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
        let cell=UpcomingmeetingTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        
        // Configure the cell...
        
        let cornerRadius: CGFloat = 6.0
        cell.uiviewupcomingmeeting.layer.cornerRadius = cornerRadius
        
        cell.uiviewupcomingmeeting.layer.masksToBounds = true
        
        
        cell.lbloppid.text="Opp ID:"+oid[indexPath.row]
        cell.lbloppid.textColor = (oid[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblexecutivenames.text="Executive Name:"+executivename[indexPath.row]
        cell.lblexecutivenames.textColor = (executivename[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcustomernames.text="Customer Name:"+customername[indexPath.row]
        cell.lblcustomernames.textColor = (customername[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblscheduledate.text="Schedule Date:"+scheduledate[indexPath.row]
        cell.lblscheduledate.textColor = (scheduledate[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblscheduletime.text="Schedule Time:"+scheduletime[indexPath.row]
        cell.lblscheduletime.textColor = (scheduletime[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        
        
        
        
        
        
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "Upcomingmeetingdetails") as!
        UpcomingmeetingdetailsctivityViewController
        
        viewcontroller.oid = oid[(UpcomingmeetingTableView.indexPathForSelectedRow?.row)!]
        viewcontroller.executivename = executivename[(UpcomingmeetingTableView.indexPathForSelectedRow?.row)!]
        viewcontroller.customername = customername[(UpcomingmeetingTableView.indexPathForSelectedRow?.row)!]
        viewcontroller.action = "Upcoming"
        
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
            let postString : String = "action=UpcommingMeeting&imei="+m_strenggimeino!+"&ver="+m_strappversion!
            
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
                        CoreDataHandlerforUpcomingmeetingview.cleardata()
                        
                        
                        if let data = data,
                            
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            if let results = json["results"] as? [[String: Any]]  {
                                for case let blog in (json["results"] as? [[String: Any]])! {
                                    //
                                    
                                    if let OID = blog["OID"] as? String {
                                        //                                                    self.companyName.append(name)
                                        let CustomerName = blog["Customer Name"] as? String
                                        let SchduleDate = blog["Schedule Date"] as? String
                                        
                                        let SchduleTime = blog["Schedule Time"] as? String
                                        let ScheduleComment = blog["Schedule Comment"] as? String
                                        let Details = blog["Details"] as? String
                                        let Ordercalue = blog["Order value"] as? String
                                        let City = blog["City"] as? String
                                        let State = blog["State"] as? String
                                        
                                        let Address = blog["Address"] as? String
                                        let ExecutiveName = blog["Executive Name"] as? String
                                        
                                        CoreDataHandlerforUpcomingmeetingview.saveObject(TicketID: OID, CustomerName: CustomerName!, Scheduldedate: SchduleDate!, Scheduldetime: SchduleTime!, Scheduldecomment: ScheduleComment!, Details: Details!, Ordervalue: Ordercalue!, City: City!, State: Address!, Address: Address!, executivename: ExecutiveName!)
                                        
                                        
                                        
                                        //                                        DispatchQueue.main.async {
                                        
                                        //                                        }
                                        
                                        
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
            
                        if(executivename != ""  || executivename != "Select" && (customername == ""  && customername == "Select") && (oid == ""  && oid == "Select")){
                            self.upcomingmeeing = CoreDataHandlerforUpcomingmeetingview.filterDataExecutivewise(executivename: executivename!)
                        }
                        if(executivename == ""  || executivename == "Select" && (customername != ""  && customername != "Select") && (oid == ""  && oid == "Select")){
                            self.upcomingmeeing=CoreDataHandlerforUpcomingmeetingview.filterDataCustNamewise(custname: customername!)
                        }
                         if(executivename == ""  || executivename == "Select" && (customername == ""  && customername == "Select") && (oid != ""  && oid != "Select")){
                            self.upcomingmeeing=CoreDataHandlerforUpcomingmeetingview.filterDataOidwise(oid: oid!)
                        }
            
            self.oid = [String]()
            self.executivename = [String]()
            self.customername = [String]()
            self.scheduledate = [String]()
            self.scheduletime = [String]()
            
            for i in self.upcomingmeeing!{
                self.oid.append(i.tickedid_umv!)
                self.executivename.append(i.executivename_umv!)
                self.customername.append(i.custname_umv!)
                self.scheduledate.append(i.scheduldedate_umv!)
                self.scheduletime.append(i.scheduldetime_umv!)
            }
            
            self.UpcomingmeetingTableView.reloadData()
            
            
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
