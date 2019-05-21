//
//  LeadViewActivityController.swift
//  UnoPointSLM
//
//  Created by Amit A on 15/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit

class LeadViewActivityController: UIViewController ,UITableViewDataSource,UITableViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
   
    //    var ticket = [Demo]()
    
    var ticket:[Leadview_lv]? = nil
    var currentItem = ""
    
    
    @IBOutlet weak var leadTableView: UITableView!
    
    var leadid = [String]()
    var customername = [String]()
    var opportunitystatus = [String]()
    var createdbyexecutive = [String]()
    var status = [String]()
    
    var filtercustomername = [String]()
    var filteropportunitystatus = [String]()
    var filtercreatedbyexecutive = [String]()
    var filterstatus = [String]()
    
    
    
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    var picker : UIPickerView!
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    
    // text fields
    @IBOutlet var tf_A: UITextField!
    @IBOutlet var tf_B: UITextField!
    @IBOutlet var tf_C: UITextField!
    @IBOutlet var tf_D: UITextField!
    
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
            leadTableView.refreshControl = refreshControl
        }else{
            leadTableView.addSubview(refreshControl)
        }
        
        
        
        downloadJson {
            self.BuildTable()
        }
        
        leadTableView.delegate=self
        leadTableView.dataSource=self
        
        
        
        // Do any additional setup after loading the view.
    }
    func BuildTable(){
        DispatchQueue.main.async {
            self.ticket=CoreDataHandlerforLeadView.fetchObject()
            //
            
            
            self.leadid = [String]()
            self.customername = [String]()
            self.opportunitystatus = [String]()
            self.createdbyexecutive = [String]()
            self.status = [String]()
            
           
            self.filtercustomername.append("Select")
            self.filteropportunitystatus.append("Select")
            self.filtercreatedbyexecutive.append("Select")
            self.filterstatus.append("Select")
            for i in self.ticket!{
                self.leadid.append(i.leadid_lv!)
                self.customername.append(i.customername_lv!)
                self.opportunitystatus.append(i.opportunitystatus_lv!)
                self.createdbyexecutive.append(i.createdbyexecutive_lv!)
                self.status.append(i.status_lv!)
                
                self.filtercustomername.append(i.customername_lv!)
                self.filteropportunitystatus.append(i.opportunitystatus_lv!)
                self.filtercreatedbyexecutive.append(i.createdbyexecutive_lv!)
                self.filterstatus.append(i.status_lv!)
                
                
            }
            
            // Call the method to dedupe the string array.
            
            if(self.filtercustomername.count>0){
                let dedupecustname = self.removeDuplicates(array: self.filtercustomername)
                self.filtercustomername = [String]()
                
                
                self.filtercustomername = dedupecustname
            }
            
            if(self.filteropportunitystatus.count>0){
                let dedupeopportunitystatus = self.removeDuplicates(array: self.filteropportunitystatus)
                self.filteropportunitystatus = [String]()
                
                
                self.filteropportunitystatus = dedupeopportunitystatus
                
            }
            if(self.filtercreatedbyexecutive.count>0){
                let dedupecreatedbyexecutive = self.removeDuplicates(array: self.filtercreatedbyexecutive)
                self.filtercreatedbyexecutive = [String]()
                
                
                self.filtercreatedbyexecutive = dedupecreatedbyexecutive
                
            }
            if(self.filterstatus.count>0){
                let dedupestatus = self.removeDuplicates(array: self.filterstatus)
                self.filterstatus = [String]()
                
                
                self.filterstatus = dedupestatus
                
            }
            
            
            self.leadTableView.reloadData()
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
        return leadid.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=leadTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        
         // Configure the cell...
        
        let cornerRadius: CGFloat = 6.0
        cell.uiviewleadview.layer.cornerRadius = cornerRadius
        
        cell.uiviewleadview.layer.masksToBounds = true
        
        
        cell.lblleadid.text="Lead ID:"+leadid[indexPath.row]
        cell.lblleadid.textColor = (leadid[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcustomername.text="Customer Name:"+customername[indexPath.row]
        cell.lblcustomername.textColor = (customername[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
       
        cell.lblopportunitystatus.text="Opportunity Status:"+opportunitystatus[indexPath.row]
        cell.lblopportunitystatus.textColor = (opportunitystatus[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        cell.lblcreatedby.text="Created By:"+createdbyexecutive[indexPath.row]
        cell.lblcreatedby.textColor = (createdbyexecutive[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
     
        cell.lblstatus.text="Status:"+status[indexPath.row]
        cell.lblstatus.textColor = (status[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
        
        
        
        
        
      
       
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "leaddetails") as!
        LeadDetailsActivityViewController
        
        viewcontroller.lid = leadid[(leadTableView.indexPathForSelectedRow?.row)!]
        
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
//         performSegue(withIdentifier: "showDetails", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination=segue.destination as? LeadDetailsActivityViewController{
//            //            destination.displaylbl.text="Hello"
//            //            destination.name = companyTableView.indexPathsForSelectedRows?.ro
////            destination.lid=leadid[(leadTableView.indexPathForSelectedRow?.row)!]
//
//        }
//    }
    
    
    //    func downloadJson(completed: @escaping () -> ()){
    //        let url = URL(string: m_stripname!+"/DeviceViewTicket.do?imei="+m_strenggimeino!+"&ver="+m_strappversion!)
    //         print(url)
    //        URLSession.shared.dataTask(with: url!) { (data, response, error) in
    ////            guard let data = data, error == nil,response != nil else {
    ////                print("Something is wrong")
    ////                return
    ////            }
    //          print("downloading")
    //
    //
    //                do{
    //                    CoreDataHandler.cleardata()
    //
    //                    if let data = data,
    //                                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
    //                                            let blogs = json["results"] as? [[String: Any]] {
    //                                            for blog in blogs {
    //                                                if let name = blog["tid"] as? String {
    ////                                                    self.companyName.append(name)
    //                                                    let panelid = blog["panelid"] as? String
    //                                                     let subticketflag = blog["SubTicketFlag"] as? String
    //
    //                                                    let incidentage = blog["Incident Age"] as? String
    //                                                    let incid = blog["incid"] as? String
    //                                                    let datetime = blog["Date Time"] as? String
    //                                                    let status = blog["Status"] as? String
    //                                                    let Category = blog["Category"] as? String
    //                                                      let SiteCode = blog["SiteCode"] as? String
    //
    ////                                                     DispatchQueue.main.async {
    //
    //                                                    CoreDataHandler.saveObject(tid: name,  panelid: panelid! ,subticketflag:subticketflag!,
    //                                                                               incidentage:incidentage!,incid:incid!,datetime:datetime!,status:status!,category: Category!,SiteCode:SiteCode!)
    ////                                                    }
    //                                                    }
    //                                            }
    //                                        }
    //
    //
    //
    //
    //
    //
    //
    //                    DispatchQueue.main.async {
    //
    //                        self.ticket=CoreDataHandler.fetchObject()
    //                        //
    //                        for i in self.ticket!{
    //                            self.ticketid.append(i.tid!)
    //                            self.AssetID.append(i.panelid!)
    //                            self.category.append(i.category!)
    //                            print(i.category!)
    //                        }
    //
    //                         self.leadTableView.reloadData()
    //                        completed()
    //                    }
    //                }catch{
    //                                    print("Json Error")
    //                                }
    //
    //
    //        }.resume()
    //
    //
    //
    //    }
    
    func downloadJson(completed: @escaping () -> ()) {
        if let url = NSURL(string: m_stripname!+"/DeviceViewLead.do") {
            //                let request = NSMutableURLRequest( url: url as URL,cac)
            var request = NSMutableURLRequest.init(url: url as URL, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 15)
            request.httpMethod = "POST"
            let postString : String = "imei="+m_strenggimeino!+"&ver="+m_strappversion!
            
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
                  CoreDataHandlerforLeadView.cleardata()
              
                        
                        if let data = data,
                            
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            if let results = json["results"] as? [[String: Any]]  {
                                for case let blog in (json["results"] as? [[String: Any]])! {
                                    //
                                    
                                    if let LeadId = blog["LeadId"] as? String {
                                        //                                                    self.companyName.append(name)
                                        let BusinessUnit = blog["Business Unit"] as? String
                                        let LeadSource = blog["Lead Source"] as? String
                                        
                                        let LeadDate = blog["Lead Date"] as? String
                                        let LeadTime = blog["Lead Time"] as? String
                                        let Description = blog["Description"] as? String
                                        let Detail = blog["Detail"] as? String
                                        let ProductCategory = blog["Product Category"] as? String
                                        let ProductSubCategory = blog["Product Sub Category"] as? String
                                        
                                        let CustomerType = blog["Customer Type"] as? String
                                        let CustomerName = blog["Customer Name"] as? String
                                        let CustomerAddress = blog["Customer Address"] as? String
                                        let State = blog["State"] as? String
                                        let City = blog["City"] as? String
                                        let OrderValue = blog["Order Value"] as? String
                                        let CustomerContactName1 = blog["Customer Contact Name1"] as? String
                                        let CustomerContactNo1 = blog["Customer Contact No1"] as? String
                                        let Emailid1 = blog["Email id1 "] as? String
                                        let Designation1 = blog["Designation1 "] as? String
                                        let CustomerContactName2 = blog["Customer Contact Name2"] as? String
                                        let CustomerContactNo2 = blog["Customer Contact No2"] as? String
                                        let Emailid2 = blog["Email id2"] as? String
                                        let Designation2 = blog["Designation2"] as? String
                                        let Status = blog["Status"] as? String
                                        let LeadCloseDate = blog["Lead Close Date"] as? String
                                        let LeadCloseTime = blog["Lead Close Time"] as? String
                                        let Disposition = blog["Disposition"] as? String
                                        let DispositionDescription = blog["Disposition Description"] as? String
                                        let CallBackDate = blog["Call Back Date"] as? String
                                        let CreatedByExecutive = blog["Created By Executive"] as? String
                                        let CreatedByRole = blog["Created By Role"] as? String
                                        let OpportunityStatus = blog["Opportunity Status"] as? String
                                        let PostalCode = blog["Postal Code"] as? String
                                        let LeadType = blog["Lead Type"] as? String
                                        let OppurtunityId = blog["OppurtunityId"] as? String
                                        let Remarks1 = blog["Remarks1"] as? String
                                        let Remarks2 = blog["Remarks2"] as? String
                                        let ExecutiveName = blog["ExecutiveName"] as? String
                                        let ExecutiveContactNo = blog["ExecutiveContactNo"] as? String
                                        
                                        
//                                        DispatchQueue.main.async {
                                       CoreDataHandlerforLeadView.saveObject(LeadId: LeadId, BusinessUnit: BusinessUnit!, LeadSource:LeadSource!, LeadDate: LeadDate!, LeadTime: LeadTime!, Description: Description!, Detail: Detail!, ProductCategory: ProductCategory!, ProductSubCategory: ProductSubCategory!, CustomerType: CustomerType!, CustomerName: CustomerName!, CustomerAddress: CustomerAddress!, State: State!, City: City!, OrderValue: OrderValue!, CustomerContactName1: CustomerContactName1!, CustomerContactNo1: CustomerContactNo1!, Emailid1: Emailid1!, Designation1: Designation1!, CustomerContactName2: CustomerContactName2!, CustomerContactNo2: CustomerContactNo2!, Emailid2: Emailid2!, Designation2: Designation2!, Status: Status!, LeadCloseDate: LeadCloseDate!, LeadCloseTime: LeadCloseTime!, Disposition: Disposition!, DispositionDescription: DispositionDescription!, CallBackDate: CallBackDate!, CreatedByExecutive: CreatedByExecutive!, CreatedByRole: CreatedByRole!, OpportunityStatus: OpportunityStatus!, PostalCode: PostalCode!, LeadType: LeadType!, OppurtunityId: OppurtunityId!, Remarks1: Remarks1!, Remarks2: Remarks2!, ExecutiveName: ExecutiveName!, ExecutiveContactNo: ExecutiveContactNo!)
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
            let customername = alertController.textFields?[0].text

            let opportunitystatus = alertController.textFields?[1].text
            let createdby = alertController.textFields?[2].text
            
            let status = alertController.textFields?[3].text

//            if((IncidentType == ""  || IncidentType == "Select") && (ProductCategory == ""  || ProductCategory == "Select")){
//                let alertController = UIAlertController(title: "UnoPoint", message:
//                    "Please select Category or Product Category For Searching", preferredStyle: UIAlertControllerStyle.alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//                return
//            }

//            if(IncidentType != ""  || IncidentType != "Select" && (ProductCategory == ""  && ProductCategory == "Select")){
//                self.ticket=CoreDataHandler.filterDataIncidentTypewise(category: IncidentType!)
//            }
//            if(ProductCategory != ""  || ProductCategory != "Select" && (IncidentType == ""  && IncidentType == "Select")){
//                self.ticket=CoreDataHandler.filterDataProductcategorywise(productcategory: ProductCategory!)
//            }
//            if(IncidentType != ""  && IncidentType != "Select" && (ProductCategory != ""  && ProductCategory != "Select")){
//                self.ticket=CoreDataHandler.filterDataProductandcategorywise(category: IncidentType!, productcategory: ProductCategory!)
//            }

            self.leadid = [String]()
            self.customername = [String]()
            self.opportunitystatus = [String]()
            self.createdbyexecutive = [String]()
            self.status = [String]()
            for i in self.ticket!{
                self.leadid.append(i.leadid_lv!)
                self.customername.append(i.customername_lv!)
                self.opportunitystatus.append(i.opportunitystatus_lv!)
                self.createdbyexecutive.append(i.createdbyexecutive_lv!)
                self.status.append(i.status_lv!)
            }

            self.leadTableView.reloadData()


        }

        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            self.tf_A = textField
            textField.placeholder = "Select Customer Name:"
            textField.delegate = self
        }

        alertController.addTextField { (textField) in
            self.tf_B = textField
            textField.placeholder = "Select Opportunity Status :"
            textField.delegate = self
        }
        alertController.addTextField { (textField) in
            self.tf_C = textField
            textField.placeholder = "Select Created By :"
            textField.delegate = self
        }
        alertController.addTextField { (textField) in
            self.tf_D = textField
            textField.placeholder = "Select Status :"
            textField.delegate = self
        }
        //        alertController.addTextField { (textField) in
        //            textField.placeholder = "Enter Email"
        //        }

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
            return filtercustomername.count
        case 2:
            return filteropportunitystatus.count
        case 3:
            return filtercreatedbyexecutive.count
        case 4:
            return filterstatus.count
        default:
            return 0
        }
    }
    // return "content" for picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // return correct content for picekr view
        switch activeTextField {
        case 1:
            return filtercustomername[row]
        case 2:
            return filteropportunitystatus[row]
        case 3:
            return filtercreatedbyexecutive[row]
        case 4:
            return filterstatus[row]
            
        default:
            return ""
        }
    }
    // get currect value for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set currect active value based on picker view
        switch activeTextField {
        case 1:
            activeValue = filtercustomername[row]
        case 2:
            activeValue = filteropportunitystatus[row]
        case 3:
            activeValue = filtercreatedbyexecutive[row]
        case 4:
            activeValue = filterstatus[row]
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
        case tf_D:
            activeTextField = 4
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
                row = filtercustomername.index(of: currentValue)
            case 2:
                row = filteropportunitystatus.index(of: currentValue)
            case 3:
                row = filtercreatedbyexecutive.index(of: currentValue)
            case 4:
                row = filterstatus.index(of: currentValue)
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
    
    
    
    
    
    
}
