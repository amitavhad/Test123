//
//  CommunicationViewActivityController.swift
//  UnoPointSLM
//
//  Created by Amit A on 13/03/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit
class CommunicationViewActivityController: UIViewController ,UITableViewDataSource,UITableViewDelegate , UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
    
    var communicationdetails:[Communicationviewmaster_cm]? = nil
    var currentItem = ""
    @IBOutlet weak var CommunicationTableView: UITableView!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var oid = [String]()
    var communicationID = [String]()
    var customername = [String]()
    var msgfrom = [String]()
    var msgto = [String]()
    var communication = [String]()
    var datetime = [String]()
    var readflag = [String]()
    
    var filtermsgfrom = [String]()
    var filtermsgto = [String]()
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
            CommunicationTableView.refreshControl = refreshControl
        }else{
            CommunicationTableView.addSubview(refreshControl)
        }
        
        
        
        downloadJson {
            self.BuildTable()
        }
        
        CommunicationTableView.delegate=self
        CommunicationTableView.dataSource=self
        
        
        // Do any additional setup after loading the view.
    }
    func BuildTable(){
        DispatchQueue.main.async {
            self.communicationdetails=CoreDataHandlerforCommunicationview.fetchData()
            
            self.oid = [String]()
            self.customername = [String]()
            self.communicationID = [String]()
            self.msgfrom = [String]()
            self.msgto = [String]()
            self.communication = [String]()
            self.datetime = [String]()
             self.readflag = [String]()
            
            
            self.filtermsgto.append("Select")
            self.filtermsgfrom.append("Select")
            self.filteroid.append("Select")
            
            for i in self.communicationdetails!{
                self.oid.append(i.ticketid_cm!)
                self.customername.append(i.customername_cm!)
                self.communicationID.append(i.cid_cm!)
                self.msgfrom.append(i.msgfrom_cm!)
                self.msgto.append(i.msgto_cm!)
                self.communication.append(i.message_cm!)
                self.datetime.append(i.datetime_cm!)
                self.readflag.append(i.communicationflag_cm!)
                
                self.filtermsgto.append(i.msgto_cm!)
                self.filtermsgfrom.append(i.msgfrom_cm!)
                self.filteroid.append(i.ticketid_cm!)
                
                
                
            }
            
            // Call the method to dedupe the string array.
            
            if(self.filtermsgto.count>0){
                let dedupemsgto = self.removeDuplicates(array: self.filtermsgto)
                self.filtermsgto = [String]()
                
                
                self.filtermsgto = dedupemsgto
            }
            
            if(self.filtermsgfrom.count>0){
                let dedupemsgfrom = self.removeDuplicates(array: self.filtermsgfrom)
                self.filtermsgfrom = [String]()
                
                
                self.filtermsgfrom = dedupemsgfrom
                
            }
            if(self.filteroid.count>0){
                let dedupeoid = self.removeDuplicates(array: self.filteroid)
                self.filteroid = [String]()
                
                
                self.filteroid = dedupeoid
                
            }
            
            
            
            self.CommunicationTableView.reloadData()
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
        let cell=CommunicationTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        
        // Configure the cell...
        
        let cornerRadius: CGFloat = 6.0
        cell.uiviewcommunication.layer.cornerRadius = cornerRadius
        
        cell.uiviewcommunication.layer.masksToBounds = true
        
        
        cell.lblcommunicationoppid.text="Opp ID:"+oid[indexPath.row]
        cell.lblcommunicationoppid.textColor = (oid[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcommunicationcustname.text="Customer Name:"+customername[indexPath.row]
        cell.lblcommunicationcustname.textColor = (customername[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcommunicationID.text="Communication ID:"+communicationID[indexPath.row]
        cell.lblcommunicationID.textColor = (communicationID[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcommunicationBy.text="By:"+msgfrom[indexPath.row]
        cell.lblcommunicationBy.textColor = (msgfrom[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcommunicationTo.text="To:"+msgto[indexPath.row]
        cell.lblcommunicationTo.textColor = (msgto[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        
        
        
        
        
        
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "communicationdetails") as!
        CommunicationDetailsActivityViewController
        
        viewcontroller.oid = oid[(CommunicationTableView.indexPathForSelectedRow?.row)!]
        viewcontroller.cid = communicationID[(CommunicationTableView.indexPathForSelectedRow?.row)!]
        
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
        //         performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func downloadJson(completed: @escaping () -> ()) {
        if let url = NSURL(string: m_stripname!+"/MDCommunication.do") {
            //                let request = NSMutableURLRequest( url: url as URL,cac)
            var request = NSMutableURLRequest.init(url: url as URL, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 15)
            request.httpMethod = "POST"
            let postString : String = "action=view&imei="+m_strenggimeino!+"&ver="+m_strappversion!
            
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
                        CoreDataHandlerforCommunicationview.cleardata()
                        
                        
                        if let data = data,
                            
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            if let results = json["results"] as? [[String: Any]]  {
                                for case let blog in (json["results"] as? [[String: Any]])! {
                                    //
                                    
                                    if let OID = blog["OID"] as? String {
                                        //                                                    self.companyName.append(name)
                                        if   let CID = blog["CID"] as? String{
                                            //                                            let SchduleDate = blog["Schedule Date"] as? String
                                            
                                            let DateTime = blog["Date Time"] as? String
                                            let Communication = blog["Communication"] as? String
                                            let By = blog["By"] as? String
                                            let To = blog["To"] as? String
                                            let ReadFlag = blog["Read Flag"] as? String
                                            let CustomerName = blog["Customer Name"] as? String
                                            
                                         
                                            CoreDataHandlerforCommunicationview.saveObject(CID: CID, OID: OID, MsgFrom: By!, MsgTo: To!, Message: Communication!, Datetime: DateTime!, Communicationflag: ReadFlag!, CustomerName: CustomerName!)
                                            
                                            
                                            
                                            
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
            let oid = alertController.textFields?[0].text
            
            let to = alertController.textFields?[1].text
            let by = alertController.textFields?[2].text
            
            
            
            self.oid = [String]()
            self.msgfrom = [String]()
            self.msgto = [String]()
            if((oid == ""  || oid == "Select") && (to == ""  || to == "Select") && (by == ""  || by == "Select")){
                let alertController = UIAlertController(title: "UnoPoint", message:
                    "Please select OID or To or By For Searching", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if((to != ""  && to != "Select") && (by == ""  || by == "Select") && (oid == ""  || oid == "Select")){
                self.communicationdetails = CoreDataHandlerforCommunicationview.filterDatamsgtowise(msgto: to!)
            }
            if((to == ""  || to == "Select") && (by != ""  && by != "Select") && (oid == ""  || oid == "Select")){
                self.communicationdetails=CoreDataHandlerforCommunicationview.filterDatamsgfromwise(msgfrom: by!)
            }
            if((to == ""  || to == "Select") && (by == ""  || by == "Select") && (oid != ""  && oid != "Select")){
                self.communicationdetails=CoreDataHandlerforCommunicationview.filterDataOIDwise(OID: oid!)
            }
            
            self.oid = [String]()
            self.customername = [String]()
            self.communicationID = [String]()
            self.msgfrom = [String]()
            self.msgto = [String]()
            self.communication = [String]()
            self.datetime = [String]()
            self.readflag = [String]()
            
            for i in self.communicationdetails!{
                self.oid.append(i.ticketid_cm!)
                self.customername.append(i.customername_cm!)
                self.communicationID.append(i.cid_cm!)
                self.msgfrom.append(i.msgfrom_cm!)
                self.msgto.append(i.msgto_cm!)
                self.communication.append(i.message_cm!)
                self.datetime.append(i.datetime_cm!)
                self.readflag.append(i.communicationflag_cm!)
            }
            
            self.CommunicationTableView.reloadData()
            
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            self.tf_A = textField
            textField.placeholder = "Select Opp ID:"
            textField.delegate = self
        }
        
        alertController.addTextField { (textField) in
            self.tf_B = textField
            textField.placeholder = "Select To :"
            textField.delegate = self
        }
        alertController.addTextField { (textField) in
            self.tf_C = textField
            textField.placeholder = "Select By :"
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
            return filteroid.count
        case 2:
            return filtermsgto.count
        case 3:
            return filtermsgfrom.count
            
        default:
            return 0
        }
    }
    // return "content" for picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // return correct content for picekr view
        switch activeTextField {
        case 1:
            return filteroid[row]
        case 2:
            return filtermsgto[row]
        case 3:
            return filtermsgfrom[row]
            
            
        default:
            return ""
        }
    }
    // get currect value for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set currect active value based on picker view
        switch activeTextField {
        case 1:
            activeValue = filteroid[row]
        case 2:
            activeValue = filtermsgto[row]
        case 3:
            activeValue = filtermsgfrom[row]
            
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
                row = filteroid.index(of: currentValue)
            case 2:
                row = filtermsgto.index(of: currentValue)
            case 3:
                row = filtermsgfrom.index(of: currentValue)
                
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
