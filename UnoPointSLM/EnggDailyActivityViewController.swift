//
//  EnggDailyActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 06/03/19.
//  Copyright © 2019 Amit A. All rights reserved.
//

import UIKit
import CoreLocation

class EnggDailyActivityViewController: UIViewController ,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    var locationManager:CLLocationManager!
    var m_strlat = ""
    var m_strlon = ""
    
    var m_strDate:String?
    var m_strFromTime:String?
    var m_strToTime:String?
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgunologo: UIImageView!
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBOutlet weak var FromTimePicker: UIDatePicker!
    
    
    @IBOutlet weak var ToTimePicker: UIDatePicker!
    
    @IBOutlet weak var txtEnterCustName: UITextField!
    
    //For Customer Master
    
    
    var picker : UIPickerView!
    
    var customer:[Customermst_cm]? = nil
    var l_stCustomer = [String]()
    var l_stCustomerID = [String]()
    
    var m_strCustomer = ""
    
    @IBOutlet weak var txtSelectCustomerName: UITextField!
    
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    
    // text fields
    //    @IBOutlet var tf_A: UITextField!
    //    @IBOutlet var tf_B: UITextField!
    
    
    var filteropportunityID = [String]()
    var filteractivityheader = [String]()
    
    var l_stActivityHeaderID = [String]()
    var m_strActivityHeader = ""
    
    @IBOutlet weak var txtSelectActivityHeader: UITextField!
    
    @IBOutlet weak var txtSelectOppID: UITextField!
    
    var ActivityHeader:[Activityheadermaster_ahm]? = nil
    var OpportunityID:[Incidentmaster_im]? = nil
    
    @IBOutlet weak var taskProgress: UIProgressView!
    @IBOutlet weak var lblserverreply: UILabel!
    @IBOutlet weak var txtActivityDescription: UITextField!
    
    @IBOutlet weak var txtActivityRemark: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Getting IPname/version/imei
        
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey: "CustomerUrl") != nil{
            
            m_stripname = preferences.object(forKey: "CustomerUrl") as! String
            m_strappversion = preferences.object(forKey: "Customerappver") as! String
            m_strenggimeino = preferences.object(forKey: "Engineerimeino") as! String
        }
        
        // set image
        self.getImage(imageName: "unopoint.png")
        
        // Get Location
        
        determineMyCurrentLocation()
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy"
        m_strDate = dateFormatter.string(from: datepicker.date)
        
        // This Logic only for Time Convert in 24 hour
        
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        let timeASString = TimeFormatter.string(from: FromTimePicker.date)
        let time = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm"
        m_strFromTime = TimeFormatter.string(from: time!)
        
        let TOtimeASString = TimeFormatter.string(from: ToTimePicker.date)
        let TOtime = TimeFormatter.date(from: TOtimeASString)
        
        m_strToTime = TimeFormatter.string(from: TOtime!)
        
        // Do any additional setup after loading the view.
        
        fillPickerview(m_strTableName: "Activityheadermaster_ahm",m_strCriteria :"activityheadermaster_ahm",m_strExtra:"")
        
    }
    func fillPickerview(m_strTableName:String,m_strCriteria:String,m_strExtra:String){
        var parameters = ""
        if(m_strTableName == "Incidentmaster_im"){
            parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria="+m_strCriteria+"&CustomerName="+m_strExtra
        }else{
            parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria="+m_strCriteria
        }
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDQueryLimited.do")!)
        print(parameters)
        print(reuest)
        
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        
        URLSession.shared.dataTask(with: reuest)  { (data, response, error) in
            
            var message =  ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                print(error!)
            }else{
                do {
                    if(m_strTableName == "Activityheadermaster_ahm"){
                        // Clear Table
                        CoreDataHandlerforLeadView.cleardatafromactivityheader()
                    }
                    if(m_strTableName == "Incidentmaster_im"){
                        // Clear Table
                        CoreDataHandlerForDailyActivity.cleardataFormIncidentmst()
                    }
                    
                    
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        if(m_strTableName == "Activityheadermaster_ahm"){
                            if let results = json["ActivityHeader"] as? [[String: Any]]  {
                                for case let blog in (json["ActivityHeader"] as? [[String: Any]])! {
                                    //
                                    
                                    if let typeID = blog["typeid"] as? String {
                                        let typevalue = blog["typevalue"] as? String
                                        CoreDataHandlerForEnggAvailabilityActivity.saveObject(typeID: typeID, typeValue: typevalue!,tablename: m_strTableName)
                                    }
                                }
                                
                            }
                            
                        }
                        if(m_strTableName == "Incidentmaster_im"){
                            if let results = json["OpportunityId"] as? [[String: Any]]  {
                                for case let blog in (json["OpportunityId"] as? [[String: Any]])! {
                                    //
                                    
                                    if let typeID = blog["typeid"] as? String {
                                        let typevalue = blog["typevalue"] as? String
                                        CoreDataHandlerForEnggAvailabilityActivity.saveObject(typeID: typeID, typeValue: typevalue!,tablename: m_strTableName)
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                if(m_strTableName == "Activityheadermaster_ahm"){
                    
                    self.ActivityHeader=CoreDataHandlerforLeadView.fetchObjectfromactivityheader()
                    self.filteractivityheader = [String]()
                    self.l_stActivityHeaderID = [String]()
                    for i in self.ActivityHeader!{
                        self.filteractivityheader.append(i.typeValue!)
                        self.l_stActivityHeaderID.append(i.typeID!)
                        
                    }
                    // delegates for text fields
                    self.txtSelectActivityHeader.delegate = self
                    self.txtSelectActivityHeader.resignFirstResponder()
                    
                    
                }
                if(m_strTableName == "Incidentmaster_im"){
                    
                    self.OpportunityID=CoreDataHandlerForDailyActivity.fetchObjectFromIncidentmst()
                    self.filteropportunityID = [String]()
                    for i in self.OpportunityID!{
                        self.filteropportunityID.append(i.typeValue!)
                        //                        self.l_stActivityHeaderID.append(i.typeID!)
                        
                    }
                    // delegates for text fields
                    self.txtSelectOppID.delegate = self
                    self.txtSelectOppID.resignFirstResponder()
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            
            
            
            }.resume()
        
    }
    
    
    @IBAction func dateSelectedFromDatePicket(_ sender: Any) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy"
        m_strDate = dateFormatter.string(from: datepicker.date)
    }
    
    @IBAction func timeSelectedFromTimePicker(_ sender: Any) {
        // This Logic only for Time Convert in 24 hour
        
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        let timeASString = TimeFormatter.string(from: FromTimePicker.date)
        let time = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm"
        m_strFromTime = TimeFormatter.string(from: time!)
        // logic end
        
    }
    
    @IBAction func timeSelectedToTimePicker(_ sender: Any) {
        // This Logic only for Time Convert in 24 hour
        
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        let timeASString = TimeFormatter.string(from: ToTimePicker.date)
        let time = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm:ss"
        m_strToTime = TimeFormatter.string(from: time!)
        // logic end
        
    }
    @IBAction func onclickCustomerSearch(_ sender: Any) {
        
        let m_strcustSearch = txtEnterCustName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(m_strcustSearch == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Customer Name For Search", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        searchcustomer()
    }
    // for Search Customer
    
    func searchcustomer(){
        
        
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria=customernamemaster_cnm&searchcriteria="+txtEnterCustName.text!
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDQueryLimited.do")!)
        
        print(reuest)
        print(parameters)
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        
        URLSession.shared.dataTask(with: reuest)  { (data, response, error) in
            
            var message =  ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                print(error!)
            }else{
                do {
                    CoreDataHandlerForDailyActivity.cleardataFormCustomermst()
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["CustomerName"] as? [[String: Any]] {
                        for blog in blogs {
                            
                            
                            if  let typeID = blog["typeid"] as? String
                            {
                                
                                let typevalue = blog["typevalue"] as? String
                                
                                CoreDataHandlerForDailyActivity.saveObject(typeID: typeID, typeValue: typevalue!, tablename: "Customermst_cm", typeextraid: "", typeextravalue: "")
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                self.customer=CoreDataHandlerForDailyActivity.fetchObjectFromCustomermst()
                self.l_stCustomerID = [String]()
                self.l_stCustomer = [String]()
                for i in self.customer!{
                    self.l_stCustomerID.append(i.typeID!)
                    self.l_stCustomer.append(i.typeValue!)
                    
                    
                }
                self.txtSelectCustomerName.delegate = self
                self.txtSelectCustomerName.resignFirstResponder()
                
                
                //                self.customerpicker.delegate = self
                //                self.customerpicker.dataSource = self
                //                self.txtSelectCustomerName.inputView = self.customerpicker
                
                
                
                
                
                
                
                
                
            }
            
            
            
            }.resume()
        
        
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        // get number of elements in each pickerview
        switch activeTextField {
        case 1:
            return filteropportunityID.count
        case 2:
            return filteractivityheader.count
            
            
        default:
            return l_stCustomer.count
        }
        
        
        
        return 0
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // return correct content for picekr view
        switch activeTextField {
        case 1:
            return filteropportunityID[row]
        case 2:
            return filteractivityheader[row]
        case 3:
            return l_stCustomer[row]
            
        default:
            return ""
        }
        
        
        return nil
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set currect active value based on picker view
        switch activeTextField {
        case 1:
            activeValue = filteropportunityID[row]
        case 2:
            activeValue = filteractivityheader[row]
            m_strActivityHeader = l_stActivityHeaderID[row]
        case 3:
            activeValue = l_stCustomer[row]
            m_strCustomer = l_stCustomerID[row]
            
            if(l_stCustomer[row] != "Select"){
                fillPickerview(m_strTableName: "Incidentmaster_im",m_strCriteria :"opportunityidmaster_aim",m_strExtra:l_stCustomer[row])
            }
        default:
            activeValue = ""
        }
        
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imgunologo.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image!")
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        m_strlat = String(lat)
        m_strlon = String(lon)
        lblLocation.text = "Location:"+m_strlat+","+m_strlon
        //        print("user latitude = \(userLocation.coordinate.latitude)")
        //        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // start editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set up correct active textField (no)
        switch textField {
        case txtSelectOppID:
            activeTextField = 1
        case txtSelectActivityHeader:
            activeTextField = 2
            
        case txtSelectCustomerName:
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
                row = filteropportunityID.index(of: currentValue)
            case 2:
                row = filteractivityheader.index(of: currentValue)
            case 3:
                row = l_stCustomer.index(of: currentValue)
                
                
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
    
    @IBAction func onclickSubmitResponse(_ sender: Any) {
        
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        let FromtimeASString = TimeFormatter.string(from: FromTimePicker.date)
        let TOtimeASString = TimeFormatter.string(from: ToTimePicker.date)
        
        
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let  m_strdate = formatter.string(from: datepicker.date)
        
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        
        let m_strFromTime = m_strdate+" "+FromtimeASString
        let m_strToTime = m_strdate+" "+TOtimeASString
        
        let firstDate = formatter.date(from: m_strFromTime)
        let secondDate = formatter.date(from: m_strToTime)
        
        if (firstDate?.compare(secondDate!) == .orderedDescending) ||  (firstDate?.compare(secondDate!) == .orderedSame) {
            let alertController = UIAlertController(title: "UnoPoint", message:
                "To Time Should Greater Than From Time", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
            
            //            print("First Date is greater then second date")
        }
        
        
        let selectIncidentID =  txtSelectOppID.text
        
        
        
        if(selectIncidentID == ""  || selectIncidentID == "Select"){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Select Incident ID", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        let selectCustomerName =  txtSelectCustomerName.text
        
        if(selectCustomerName == ""  || selectCustomerName == "Select"){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Select Customer Name", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        let selectActivityHeader =  txtSelectActivityHeader.text
        
        if(selectActivityHeader == ""  || selectActivityHeader == "Select"){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Select Activity Header", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        
        let Description = txtActivityDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(Description == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Activity Description", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        let Remark = txtActivityRemark.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(Remark == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Activity Remark", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        createAlert(title: "UnoPoint", message: "Do you Want to submit")
    }
    
    
    
    
    func  createAlert(title:String,message:String){
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: {(action) in
            self.DailyActivitysubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func DailyActivitysubmit(){
        
        let replacedDate = m_strDate?.replacingOccurrences(of: "/", with: "")
        
        let Arrfromtime = m_strFromTime?.components(separatedBy: ":")
        let fromtimehour = Arrfromtime![0]
        let fromtimeminute = Arrfromtime![1]
        
        let ArrTotime = m_strToTime?.components(separatedBy: ":")
        let totimehour = ArrTotime![0]
        let totimeminute = ArrTotime![1]
        
        
        //        let replacedToDate = m_strToDate?.replacingOccurrences(of: "/", with: "-")
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=submit&lat="+m_strlat+"&lon="+m_strlon+"&OID="+txtSelectOppID.text!+"&datetime="+replacedDate!+fromtimehour+fromtimeminute+totimehour+totimeminute+"&CustId="+m_strCustomer+"&ActivityDesc="+txtActivityDescription.text!+"&ActivityRemark="+txtActivityRemark.text!+"&ActivityHeader="+m_strActivityHeader
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDDailyActivity.do")!)
        
        print(reuest)
        print(parameters)
        
        self.taskProgress.progress = Float(0.30)
        
        reuest.httpMethod = "Post"
        reuest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        reuest.addValue("application/json", forHTTPHeaderField: "Accept")
        reuest.httpBody = parameters.data(using : .utf8)
        
        self.taskProgress.progress = Float(0.60)
        URLSession.shared.dataTask(with: reuest)  { (data, response, error) in
            
            var message =  ""
            if  error != nil{
                
                message = "Error Connecting check Internet Connection."
                print(error!)
            }else{
                do {
                    
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        if let results = json["Reply"] as? [[String: Any]]  {
                            for case let result in (json["Reply"] as? String)! {
                                
                                message =  (json["Reply"] as? String)!
                            }
                            
                        }
                        if let results = json["results"] as? [[String: Any]]  {
                         
                            for blog in results {
                                    
                                    
                                    if  let reply = blog["Reply"] as? String
                                    {
                                        
                                        
                                        message = reply
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                
                           
                            
                        }
                    }
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                if(message == ""){
                    message = "Error Connecting check Internet Connection."
                }
                self.lblserverreply.text = "Server Reply: "+message
                self.taskProgress.progress = Float(1.0)
            }
            
            
            //                        self.btnshowmenu.isHidden=true
            }.resume()
        
        
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
