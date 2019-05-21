//
//  LeadCloseActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 23/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreLocation

class LeadCloseActivityViewController: UIViewController, CheckboxDialogViewDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

     var checkboxDialogViewController: CheckboxDialogViewController!
    //define typealias-es
    typealias TranslationTuple = (name: String, translated: String)
    typealias TranslationDictionary = [String : String]
    
    @IBOutlet weak var txtDespositionDesc: UITextField!
    
    @IBOutlet weak var lblcompanyTrademark: UILabel!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    var locationManager:CLLocationManager!
    
    var m_strlat = ""
    var m_strlon = ""
    var leadid = ""
    
    @IBOutlet weak var imgunologo: UIImageView!
    
    @IBOutlet weak var lblleadID: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    var l_stDesposID = [String]()
    
    var l_stDespos = [String] ()
    
    var pickerview=UIPickerView()
    var m_strDesposID = ""
    
    
    @IBOutlet weak var txtSelectDispos: UITextField!
//    @IBOutlet weak var txtSelectDisposDesc: UITextField!
    
    @IBOutlet weak var taskProgress: UIProgressView!
    
    @IBOutlet weak var lblserverreply: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var m_strDate = ""
    
    @IBOutlet weak var FromtimePicker: UIDatePicker!
    var m_strFromTime = ""
    
    @IBOutlet weak var TotimePicker: UIDatePicker!
    var  m_strToTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblleadID.text = "Lead ID:"+leadid
        lblcompanyTrademark.text = Constants.companytrademarkname
        
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
        
        fillPickerview(m_strTableName: "Leaddespositionmast_ldm",m_strCriteria :"leaddespositionmast_ldm")
        fillPickerview(m_strTableName: "Leaddespdescmst_lddm",m_strCriteria :"leaddespdescmst_lddm")
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "ddMMyyyy"
        m_strDate = dateFormatter.string(from: datePicker.date)
        
        print("Date:"+m_strDate)
        
        // This Logic only for Time Convert in 24 hour
        // For From Time
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        var timeASString = TimeFormatter.string(from: FromtimePicker.date)
        let Fromtime = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HHmm"
        m_strFromTime =  TimeFormatter.string(from: Fromtime!)
        print("From Time:"+m_strFromTime)
        
        // For To time
        
        TimeFormatter.dateFormat = "hh:mm:ss a"
        timeASString = TimeFormatter.string(from: TotimePicker.date)
        let Totime = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HHmm"
        m_strToTime =  TimeFormatter.string(from: Totime!)
        print("To Time:"+m_strToTime)
        
        
        
        
        // logic end
        
        // Do any additional setup after loading the view.
    }
    @IBAction func dateSelectedFromDatePicket(_ sender: Any) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "ddMMyyyy"
        m_strDate = dateFormatter.string(from: datePicker.date)
        
        print("Date:"+m_strDate)
        
        
        
        
    }
    
    
    @IBAction func timeSelectedFromTimePicker(_ sender: Any) {
        // This Logic only for Time Convert in 24 hour
        
        // For From Time
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        var timeASString = TimeFormatter.string(from: FromtimePicker.date)
        let Fromtime = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HHmm"
        m_strFromTime =  TimeFormatter.string(from: Fromtime!)
        print("From Time:"+m_strFromTime)
        // logic end
        
    }
    @IBAction func timeSelectedToTimePicker(_ sender: Any) {
        // This Logic only for Time Convert in 24 hour
        
        // For To time
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        var timeASString = TimeFormatter.string(from: TotimePicker.date)
        let Totime = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HHmm"
        m_strToTime =  TimeFormatter.string(from: Totime!)
        print("To Time:"+m_strToTime)
        // logic end
        
    }
    
    
    func fillPickerview(m_strTableName:String,m_strCriteria:String){
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria="+m_strCriteria
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDQueryDropDown.do")!)
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
                    if(m_strTableName == "Leaddespositionmast_ldm"){
                        // Clear Table
                        CoreDataHandlerforLeadView.cleardatafromleaddespositionmst()
                    }else if(m_strTableName == "Leaddespdescmst_lddm"){
                        // Clear Table
                        CoreDataHandlerforLeadView.cleardatafromleaddespositiondescmst()
                        
                    }
                    
                    
                    if let data = data,
                        
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        if(m_strTableName == "Leaddespositionmast_ldm"){
                            if let results = json["leaddespositionId"] as? [[String: Any]]  {
                                for case let blog in (json["leaddespositionId"] as? [[String: Any]])! {
                                    //
                                    
                                    if let typeID = blog["typeid"] as? String {
                                        let typevalue = blog["typevalue"] as? String
                                        CoreDataHandlerForEnggAvailabilityActivity.saveObject(typeID: typeID, typeValue: typevalue!,tablename: m_strTableName)
                                    }
                                }
                                
                            }
                            
                        }else  if(m_strTableName == "Leaddespdescmst_lddm"){
                            if let results = json["leaddesdescriptionId"] as? [[String: Any]]  {
                                for case let blog in (json["leaddesdescriptionId"] as? [[String: Any]])! {
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
                if(m_strTableName == "Leaddespositionmast_ldm"){
                    var DespositionDesc:[Leaddespositionmast_ldm]? = nil
                  DespositionDesc=CoreDataHandlerforLeadView.fetchObjectfromleaddespositionmst()
                    
                    for i in DespositionDesc!{
                        self.l_stDespos.append(i.typeValue!)
                        self.l_stDesposID.append(i.typeID!)
                        
                    }
                   
                    self.pickerview.delegate = self
                    self.pickerview.dataSource = self
                    self.txtSelectDispos.inputView = self.pickerview 
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            
            
            
            }.resume()
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return l_stDespos.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return l_stDespos[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //todo
        
        txtSelectDispos.text=l_stDespos[row]
        m_strDesposID=l_stDesposID[row]
        txtSelectDispos.resignFirstResponder()
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onclickSubmitResponse(_ sender: Any) {
        
        let selectDispos =  txtSelectDispos.text
        
        
        //        let selectActivity = txtSelectActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(selectDispos == "" || selectDispos == "Select"){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Select Disposition", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let DisposDesc = txtDespositionDesc.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(DisposDesc == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Disposition Desc", preferredStyle: UIAlertControllerStyle.alert)
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
            self.Leadclosesubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func Leadclosesubmit(){
//m_strDesposID = "2"
       var m_strDateTime = m_strDate+m_strFromTime+m_strToTime
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=submit"+"&lat="+m_strlat+"&lon="+m_strlon+"&leadclosedatetime="+m_strDateTime+"&dispositionId="+m_strDesposID+"&Dispositiondescription="+txtDespositionDesc.text!+"&Lead_ID="+leadid

        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDLeadCloseActivity.do")!)
        
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
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["results"] as? [[String: Any]] {
                        for blog in blogs {
                            
                            
                            if  let reply = blog["Reply"] as? String
                            {
                                //                                print(name1)
                                
                                message = reply
                                
                                
                                
                                
                                
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
                if(message == "UnRegister"){
                    let preferences = UserDefaults.standard
                    // store string value
                    
                    preferences.set("Unregister", forKey: "RegisterStatus")
                    preferences.set("", forKey: "OTP") as? Int
                    //  Save to disk
                    let didSave = preferences.synchronize()
                    
                    if !didSave {
                        //  Couldn't save (I've never seen this happen in real world testing)
                    }
                }
                self.lblserverreply.text = "Server Reply: "+message
                self.taskProgress.progress = Float(1.0)
            }
            
            
            //                        self.btnshowmenu.isHidden=true
            }.resume()
        
        
    }
    
    
    
    
    @IBAction func showDispositionDescDialogue(_ sender: Any) {
        // this tuple has translated key because it can use localized values in case app needs to be localized
        var tableData: [TranslationTuple] = []
        var leaddesdesc:[Leaddespdescmst_lddm]? = nil
        leaddesdesc=CoreDataHandlerforLeadView.fetchObjectfromleaddespositiondescmst()
        for i in leaddesdesc!{
            tableData.append((name: i.typeValue!, translated: i.typeValue!))
        }
       
        
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
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imgunologo.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image!")
        }
    }
    // Location service start
    
   
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
