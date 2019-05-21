
//
//  LeadCallTrackActivityViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 20/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit
import CoreLocation

class LeadCallTrackActivityViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate,UITextFieldDelegate{
    var ActivityHeader:[Activityheadermaster_ahm]? = nil
    var LocationMaster:[Locationmaster_lm]? = nil
    var leadid = ""
    @IBOutlet weak var lblcompanyTrademark: UILabel!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    var locationManager:CLLocationManager!
    
    var m_strlat = ""
    var m_strlon = ""
    
    @IBOutlet weak var imgunologo: UIImageView!
    
    
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
     var picker : UIPickerView!
    // text fields
//    @IBOutlet var tf_A: UITextField!
//    @IBOutlet var tf_B: UITextField!
    
    
    
    var filteractivityheader = [String]()
    var filterlocation = [String]()
    
  
    
    
    
    @IBOutlet weak var lblleadID: UILabel!
    @IBOutlet weak var txtActivityHeader: UITextField!
    
    
    
    
    @IBOutlet weak var txtLocation: UITextField!
    
    
    @IBOutlet weak var txtRemarks: UITextField!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblserverreply: UILabel!
    
    var m_strDate = ""
    var m_strFromTime = ""
    var m_strToTime = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var FromtimePicker: UIDatePicker!
    
    
    @IBOutlet weak var TotimePicker: UIDatePicker!
    
    @IBOutlet weak var taskProgress: UIProgressView!
    
    // variable for storing value
    
    var m_strLocation = ""
      var l_stLocationID =  [String]()
    
      var m_strActivityHeader = ""
    var l_stActivityHeaderID = [String]()
    
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
        
        fillPickerview(m_strTableName: "Activityheadermaster_ahm",m_strCriteria :"activityheadermaster_ahm")
        fillPickerview(m_strTableName: "Locationmaster_lm",m_strCriteria :"locationmaster_ahm")
        
        
     
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        m_strDate = dateFormatter.string(from: datePicker.date)
        
        print("Date:"+m_strDate)
        
        // This Logic only for Time Convert in 24 hour
        // For From Time
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        var timeASString = TimeFormatter.string(from: FromtimePicker.date)
        let Fromtime = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm:ss"
        m_strFromTime =  TimeFormatter.string(from: Fromtime!)
        print("From Time:"+m_strFromTime)
        
        // For To time
        
        TimeFormatter.dateFormat = "hh:mm:ss a"
         timeASString = TimeFormatter.string(from: TotimePicker.date)
        let Totime = TimeFormatter.date(from: timeASString)
        TimeFormatter.dateFormat = "HH:mm:ss"
        m_strToTime =  TimeFormatter.string(from: Totime!)
        print("To Time:"+m_strToTime)
        
        
        
        
        // logic end
      
        
        // Do any additional setup after loading the view.
    }
    @IBAction func dateSelectedFromDatePicket(_ sender: Any) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
        TimeFormatter.dateFormat = "HH:mm:ss"
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
        TimeFormatter.dateFormat = "HH:mm:ss"
        m_strToTime =  TimeFormatter.string(from: Totime!)
        print("To Time:"+m_strToTime)
        // logic end
        
    }
    
    
    @IBAction func onclickSubmitResponse(_ sender: Any) {
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "hh:mm:ss a"
        let FromtimeASString = TimeFormatter.string(from: FromtimePicker.date)
        let TOtimeASString = TimeFormatter.string(from: TotimePicker.date)
        
        
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let  m_strdate = formatter.string(from: datePicker.date)
        
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
        let Remark = txtRemarks.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(Remark == ""){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Enter Remark", preferredStyle: UIAlertControllerStyle.alert)
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
            self.CallTrackActivitysubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func CallTrackActivitysubmit(){
        
//    let parameters = ""
//
        var  m_strStatus = "CallTrack";
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&lat="+m_strlat+"&lon="+m_strlon+"&Date="+m_strDate+"&Time="+m_strFromTime+"&StatusName="+m_strStatus+"&Remarks="+txtRemarks.text!+"&Lead_ID="+leadid+"&ToTime="+m_strToTime+"&ActivityHeader="+txtActivityHeader.text!+"&Location="+txtLocation.text!
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDCallBackAndCallTrack.do")!)
        
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

    
    func fillPickerview(m_strTableName:String,m_strCriteria:String){
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria="+m_strCriteria
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
                    }else if(m_strTableName == "Locationmaster_lm"){
                        // Clear Table
                        CoreDataHandlerforLeadView.cleardatafromlocationmaster()
                        
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
                            
                        }else  if(m_strTableName == "Locationmaster_lm"){
                            if let results = json["LocationMaster"] as? [[String: Any]]  {
                                for case let blog in (json["LocationMaster"] as? [[String: Any]])! {
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
                    
                    for i in self.ActivityHeader!{
                        self.filteractivityheader.append(i.typeValue!)
                        self.l_stActivityHeaderID.append(i.typeID!)
                       
                    }
                    // delegates for text fields
                    self.txtActivityHeader.delegate = self
                       self.txtActivityHeader.resignFirstResponder()
                 
                    
                }else if(m_strTableName == "Locationmaster_lm"){
                    self.LocationMaster=CoreDataHandlerforLeadView.fetchObjectfromlocationmaster()
                    
                    for i in self.LocationMaster!{
                        self.l_stLocationID.append(i.typeID!)
                        self.filterlocation.append(i.typeValue!)
                    }
                       self.txtLocation.delegate = self
                    
                }
                
                
                
                
                
                
                
                
            }
            
            
            
            }.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Location service start
    
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
    // number of components in picekr view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // return number of elements in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // get number of elements in each pickerview
        switch activeTextField {
        case 1:
            return filteractivityheader.count
        case 2:
            return filterlocation.count
        default:
            return 0
        }
    }
    // return "content" for picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // return correct content for picekr view
        switch activeTextField {
        case 1:
            return filteractivityheader[row]
        case 2:
            return filterlocation[row]
            
        default:
            return ""
        }
    }
    // get currect value for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set currect active value based on picker view
        switch activeTextField {
        case 1:
            activeValue = filteractivityheader[row]
            m_strActivityHeader = l_stActivityHeaderID[row]
        case 2:
            activeValue = filterlocation[row]
            m_strLocation = l_stLocationID[row]
        default:
            activeValue = ""
        }
    }
    // start editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set up correct active textField (no)
        switch textField {
        case txtActivityHeader:
            activeTextField = 1
        case txtLocation:
            activeTextField = 2
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
                row = filteractivityheader.index(of: currentValue)
            case 2:
                row = filterlocation.index(of: currentValue)
                
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
    
    
    
    
    
    
    // Location service end
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
