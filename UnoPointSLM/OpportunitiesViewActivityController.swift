//
//  OpportunitiesViewActivityController.swift
//  UnoPointSLM
//
//  Created by Amit A on 26/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit

class OpportunitiesViewActivityController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    var ticket:[Ticketview_tv]? = nil

   
    @IBOutlet weak var OppTableView: UITableView!
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var picker : UIPickerView!

    var oid = [String]()
    var customername = [String]()
    var internalprogress = [String]()
    var externalprogress = [String]()
    var executivenaem = [String]()
    
    
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    
    
    var filtercustomername = [String]()
    var filterinternalprogress = [String]()
    var filterexternalprogress = [String]()
    var filterexecutive = [String]()
    
    // text fields
    @IBOutlet var tf_A: UITextField!
    @IBOutlet var tf_B: UITextField!
    @IBOutlet var tf_C: UITextField!
    @IBOutlet var tf_D: UITextField!

    var currentItem = ""

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
            OppTableView.refreshControl = refreshControl
        }else{
            OppTableView.addSubview(refreshControl)
        }



        downloadJson {
            self.BuildTable()
        }

        OppTableView.delegate=self
        OppTableView.dataSource=self



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func BuildTable(){
        DispatchQueue.main.async {
            self.ticket=CoreDataHandlerforOppView.fetchObject()
            //


            self.oid = [String]()
            self.customername = [String]()
            self.internalprogress = [String]()
            self.externalprogress = [String]()
            self.executivenaem = [String]()


            self.filtercustomername.append("Select")
            self.filterinternalprogress.append("Select")
            self.filterexternalprogress.append("Select")
            self.filterexecutive.append("Select")
            for i in self.ticket!{
                self.oid.append(i.ticketid_tv!)
                self.customername.append(i.customername2_tv!)
                self.internalprogress.append(i.progressname_tv!)
                self.externalprogress.append(i.externalprogressname_tv!)
                self.executivenaem.append(i.engineername_tv!)

                self.filtercustomername.append(i.customername2_tv!)
                self.filterinternalprogress.append(i.progressname_tv!)
                self.filterexternalprogress.append(i.externalprogressname_tv!)
                self.filterexecutive.append(i.engineername_tv!)


            }

            // Call the method to dedupe the string array.

            if(self.filtercustomername.count>0){
                let dedupecustname = self.removeDuplicates(array: self.filtercustomername)
                self.filtercustomername = [String]()


                self.filtercustomername = dedupecustname
            }
//
            if(self.filterinternalprogress.count>0){
                let dedupeinternalprogress = self.removeDuplicates(array: self.filterinternalprogress)
                self.filterinternalprogress = [String]()


                self.filterinternalprogress = dedupeinternalprogress

            }
//            if(self.filtercreatedbyexecutive.count>0){
//                let dedupecreatedbyexecutive = self.removeDuplicates(array: self.filtercreatedbyexecutive)
//                self.filtercreatedbyexecutive = [String]()
//
//
//                self.filtercreatedbyexecutive = dedupecreatedbyexecutive
//
//            }
//            if(self.filterstatus.count>0){
//                let dedupestatus = self.removeDuplicates(array: self.filterstatus)
//                self.filterstatus = [String]()
//
//
//                self.filterstatus = dedupestatus
//
//            }


            self.OppTableView.reloadData()
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
        let cell=OppTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell


        // Configure the cell...
        
        
        
        
      

        let cornerRadius: CGFloat = 6.0
        cell.uiviewoppview.layer.cornerRadius = cornerRadius

        cell.uiviewoppview.layer.masksToBounds = true


        cell.lbloid.text="OID:"+oid[indexPath.row]
        cell.lbloid.textColor = (oid[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray

        cell.lbloidcustomername.text="Customer Name:"+customername[indexPath.row]
        cell.lbloidcustomername.textColor = (customername[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray

        cell.lblinternalprogress.text="Internal Progress:"+internalprogress[indexPath.row]
        cell.lblinternalprogress.textColor = (internalprogress[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
//
        cell.lblexeternalprogress.text="External Progress:"+externalprogress[indexPath.row]
        cell.lblexeternalprogress.textColor = (externalprogress[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
//
        cell.lblexecutivename.text="Executive Name:"+executivenaem[indexPath.row]
        cell.lblexecutivename.textColor = (executivenaem[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray







        return cell



    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "leaddetails") as!
//        LeadDetailsActivityViewController
//
//        viewcontroller.lid = oid[(OppTableView.indexPathForSelectedRow?.row)!]
//
//        self.navigationController?.pushViewController(viewcontroller, animated: true)

        
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "oppdetails") as!
        OppDetailsActivityViewController

        viewcontroller.oid = oid[(OppTableView.indexPathForSelectedRow?.row)!]

        self.navigationController?.pushViewController(viewcontroller, animated: true)


    }



    func downloadJson(completed: @escaping () -> ()) {
        if let url = NSURL(string: m_stripname!+"/DeviceViewTicket.do") {
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
                        CoreDataHandlerforOppView.cleardata()


                        if let data = data,

                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            if let results = json["results"] as? [[String: Any]]  {
                                for case let blog in (json["results"] as? [[String: Any]])! {
                                    //

                                    if let LeadId = blog["oid"] as? String {
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        //                                                    self.companyName.append(name)
                                        let oid = blog["oid"] as? String
                                        let CustomerName = blog["Customer Name"] as? String

                                        let ProgressName = blog["Progress Name"] as? String
                                        let ExternalProgress = blog["External Progress"] as? String
                                        let Category = blog["Category"] as? String
                                        let Status = blog["Status"] as? String
                                        let IncidentAge = blog["Incident Age"] as? String
                                        let DateTime = blog["Date Time"] as? String

                                        let AssignedDateTime = blog["Assigned Date Time"] as? String
                                        let KSYSSLA = blog["KSYS SLA"] as? String
                                        let HCILSLA = blog["HCIL SLA"] as? String
                                        let ScheduleDateTime = blog["Schedule Date Time"] as? String
                                        let OrderValue = blog["Order Value"] as? String
                                        let CustomerAddress = blog["Customer Address"] as? String
                                        let EngineerName = blog["Engineer Name"] as? String
                                        let EngineerContactNo = blog["Engineer Contact No"] as? String
                                        let CustomerContact1 = blog["Customer Contact1"] as? String
                                        let CustomerContact2 = blog["Customer Contact2"] as? String
                                        let CreatedBy = blog["Created By"] as? String
                                        let LeadID = blog["LeadID"] as? String
                                        let Product_Price_Approval_Status = blog["Product_Price_Approval_Status"] as? String
                                        let CustomerEmailID1 = blog["Customer EmailID1"] as? String
                                        let CustomerContactName2 = blog["Customer ContactName2"] as? String
                                        let CustomerEmailID2 = blog["Customer EmailID2"] as? String
                                        let CustomerContactNo2 = blog["Customer ContactNo2"] as? String
                                        let CustomerTypeId = blog["CustomerTypeId"] as? String
                                        let OTP = blog["OTP"] as? String
                                        

                                        //                                        DispatchQueue.main.async {
                                        CoreDataHandlerforOppView.saveObject(
                                            oid: oid!,
                                            CustomerName: CustomerName!,
                                            ProgressName: ProgressName!,
                                            ExternalProgress: ExternalProgress!,
                                            Category: Category!,
                                            Status: Status!,
                                            IncidentAge: IncidentAge!,
                                            DateTime: DateTime!,
                                            AssignedDateTime: AssignedDateTime!,
                                            KSYSSLA: KSYSSLA!,
                                            HCILSLA: HCILSLA!,
                                            ScheduleDateTime: ScheduleDateTime!,
                                            OrderValue: OrderValue!,
                                            CustomerAddress: CustomerAddress!,
                                            EngineerName: EngineerName!,
                                            EngineerContactNo: EngineerContactNo!,
                                            CustomerContact1: CustomerContact1!,
                                            CustomerContact2: CustomerContact2!,
                                            CreatedBy: CreatedBy!,
                                            LeadID: LeadID!,
                                            Product_Price_Approval_Status: Product_Price_Approval_Status!,
                                            CustomerEmailID1: CustomerEmailID1!,
                                            CustomerContactName2: CustomerContactName2!,
                                            CustomerEmailID2: CustomerEmailID2!,
                                            CustomerContactNo2: CustomerContactNo2!,
                                            CustomerTypeId: CustomerTypeId!,
                                            OTP: OTP!
                                        )
                                        //                                        }


                                    }
                                }

                            }


                        }



                        //                        }







                        //                                    DispatchQueue.main.async {
                        //
                        self.BuildTable()


                        completed()
//                                                            }
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

            let Internalprogress = alertController.textFields?[1].text
            let Externalprogress = alertController.textFields?[2].text

            let Executive = alertController.textFields?[3].text

//                        if((IncidentType == ""  || IncidentType == "Select") && (ProductCategory == ""  || ProductCategory == "Select")){
//                            let alertController = UIAlertController(title: "UnoPoint", message:
//                                "Please select Category or Product Category For Searching", preferredStyle: UIAlertControllerStyle.alert)
//                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//                            self.present(alertController, animated: true, completion: nil)
//                            return
//                        }
//
//                        if(IncidentType != ""  || IncidentType != "Select" && (ProductCategory == ""  && ProductCategory == "Select")){
//                            self.ticket=CoreDataHandler.filterDataIncidentTypewise(category: IncidentType!)
//                        }
//                        if(ProductCategory != ""  || ProductCategory != "Select" && (IncidentType == ""  && IncidentType == "Select")){
//                            self.ticket=CoreDataHandler.filterDataProductcategorywise(productcategory: ProductCategory!)
//                        }
//                        if(IncidentType != ""  && IncidentType != "Select" && (ProductCategory != ""  && ProductCategory != "Select")){
//                            self.ticket=CoreDataHandler.filterDataProductandcategorywise(category: IncidentType!, productcategory: ProductCategory!)
//                        }

            self.oid = [String]()
            self.customername = [String]()
            self.internalprogress = [String]()
            self.externalprogress = [String]()
            self.executivenaem = [String]()
            for i in self.ticket!{
                self.oid.append(i.ticketid_tv!)
                self.customername.append(i.customername2_tv!)
                self.internalprogress.append(i.progressname_tv!)
                self.externalprogress.append(i.externalprogressname_tv!)
                self.executivenaem.append(i.engineername_tv!)
            }

            self.OppTableView.reloadData()


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
            textField.placeholder = "Select Internal Progress :"
            textField.delegate = self
        }
        alertController.addTextField { (textField) in
            self.tf_C = textField
            textField.placeholder = "Select External Progress :"
            textField.delegate = self
        }
        alertController.addTextField { (textField) in
            self.tf_D = textField
            textField.placeholder = "Select Executive :"
            textField.delegate = self
        }
//                alertController.addTextField { (textField) in
//                    textField.placeholder = "Enter Email"
//                }

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
            return filterinternalprogress.count
        case 3:
            return filterexternalprogress.count
        case 4:
            return filterexecutive.count
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
            return filterinternalprogress[row]
        case 3:
            return filterexternalprogress[row]
        case 4:
            return filterexecutive[row]
            
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
            activeValue = filterinternalprogress[row]
        case 3:
            activeValue = filterexternalprogress[row]
        case 4:
            activeValue = filterexecutive[row]
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
                row = filterinternalprogress.index(of: currentValue)
            case 3:
                row = filterexternalprogress.index(of: currentValue)
            case 4:
                row = filterexecutive.index(of: currentValue)
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
