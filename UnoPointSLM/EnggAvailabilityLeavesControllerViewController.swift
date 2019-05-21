//
//  EnggAvailabilityLeavesControllerViewController.swift
//  UnoPointSLM
//
//  Created by Amit A on 12/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit
import CoreLocation

class EnggAvailabilityLeavesController: UIViewController  ,UITableViewDataSource,UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var TableView: UITableView!
    
    
    var enggsummary:[EngineerLeaveSummarymst_elsm]? = nil
    var leavetypemst:[Leavetypemaster_ltm]? = nil
    
    var leavetype = [String]()
    var leavetypevalue = [String]()
    
    
    
    @IBOutlet weak var lblserverreply: UILabel!
    
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtSelectLeaveType: UITextField!
    
    var m_stripname:String?
    var m_strappversion:String?
    var m_strenggimeino:String?
    
    var locationManager:CLLocationManager!
    
    var m_strlat = ""
    var m_strlon = ""
    
    @IBOutlet weak var imgunologo: UIImageView!
    
    var l_stLeaveTypeID = [String]()
    
    var l_stLeaveType = [String] ()
    
    var pickerview=UIPickerView()
    var m_strLeaveTypeID:String?
    
    @IBOutlet weak var taskProgress: UIProgressView!
    
    
    @IBOutlet weak var btnsubmit: UIButton!
    
    
    @IBOutlet weak var FromdatePicker: UIDatePicker!
    
    @IBOutlet weak var TodatePicker: UIDatePicker!
    
    var m_strFromDate:String?
    var m_strToDate:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        self.taskProgress.progress = Float(0.0)
        
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
        
        
        fillengineersummarytable()
        
        
        fillLeaveType()
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd"
        m_strFromDate = dateFormatter.string(from: FromdatePicker.date)
        
        m_strToDate = dateFormatter.string(from: TodatePicker.date)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dateSelectedFromDatePicket(_ sender: Any) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd"
        m_strFromDate = dateFormatter.string(from: FromdatePicker.date)
        
        
        
        
    }
    
    @IBAction func dateSelectedTODatePicket(_ sender: Any) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd"
        m_strToDate = dateFormatter.string(from: TodatePicker.date)
        
        
        
        
    }
    
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return l_stLeaveType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return l_stLeaveType[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //todo
        
        txtSelectLeaveType.text=l_stLeaveType[row]
        m_strLeaveTypeID=l_stLeaveTypeID[row]
        txtSelectLeaveType.resignFirstResponder()
    }
    
    
    
    
    // for Enginner summary tabel
    
    func fillengineersummarytable(){
        
        
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria=executiveleavesummary"
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDQueryLimited.do")!)
        
        
        
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
                    CoreDataHandlerForEnggAvailabilityActivity.cleardataFormenggsummarymst()
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["EngineerLeaveSummaryTable"] as? [[String: Any]] {
                        for blog in blogs {
                            
                            
                            if  let typeID = blog["typeid"] as? String
                            {
                                
                                let typevalue = blog["typevalue"] as? String
                                
                                
                                //                                DispatchQueue.main.async {
                                
                                CoreDataHandlerForEnggAvailabilityActivity.saveObject(typeID: typeID, typeValue: typevalue!,tablename: "EngineerLeaveSummarymst_elsm")
                                
                                //                                }
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                self.enggsummary=CoreDataHandlerForEnggAvailabilityActivity.fetchObjectFromENgineerLeaveSummarymst()
                
                for i in self.enggsummary!{
                    self.leavetypevalue.append(i.typeID!)
                    self.leavetype.append(i.typeValue!)
                    
                }
                self.TableView.reloadData()
                
                self.TableView.delegate=self
                self.TableView.dataSource=self
                
                
                
            }
            
            
            
            }.resume()
        
        
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leavetype.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell=TableView.dequeueReusableCell(withIdentifier: "cell") as ? TableViewCell
        //        //
        //        cell?.lblleavesummary?.text=leavetype[indexPath.row]+":"+leavetypevalue[indexPath.row]
        //        //        cell?.detailTextLabel?.text=""
        //
        ////        cell?.detailTextLabel?.text=
        
        let cell=TableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.lblleavesummary.text=leavetype[indexPath.row]+":"+leavetypevalue[indexPath.row]
        
        return cell
        
        
    }
    
    // for Leave Type
    
    func fillLeaveType(){
        
        
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&criteria=leavetypemaster_ltm"
        var reuest = URLRequest(url: URL(string: m_stripname!+"/MDLeaveTypeMaster.do")!)
        
        
        
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
                    CoreDataHandlerForEnggAvailabilityActivity.cleardataFormLeavTypemst()
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["LeaveType"] as? [[String: Any]] {
                        for blog in blogs {
                            
                            
                            if  let typeID = blog["typeid"] as? String
                            {
                                
                                let typevalue = blog["typevalue"] as? String
                                
                                
                                //                                DispatchQueue.main.async {
                                
                                CoreDataHandlerForEnggAvailabilityActivity.saveObject(typeID: typeID, typeValue: typevalue!,tablename: "Leavetypemaster_ltm")
                                
                                //                                }
                                
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    
                    
                }
                
            }
            DispatchQueue.main.async {
                
                self.leavetypemst=CoreDataHandlerForEnggAvailabilityActivity.fetchObjectFromLeavetypemaster()
                
                for i in self.leavetypemst!{
                    self.l_stLeaveTypeID.append(i.typeID!)
                    self.l_stLeaveType.append(i.typeValue!)
                    
                }
                self.pickerview.delegate = self
                self.pickerview.dataSource = self
                self.txtSelectLeaveType.inputView = self.pickerview
//                self.txtSelectLeaveType.textAlignment = .center
                
                
                
            }
            
            
            
            }.resume()
        
        
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
    
    
    
    
    
    @IBAction func onclickSubmitResponse(_ sender: Any) {
        
        let selectLeaveType =  txtSelectLeaveType.text
        
        
        //        let selectActivity = txtSelectActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(selectLeaveType == "" || selectLeaveType == "Select"){
            let alertController = UIAlertController(title: "UnoPoint", message:
                "Please Select Leave Type", preferredStyle: UIAlertControllerStyle.alert)
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
            self.Leavesubmit()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: {(action) in
            alertController.dismiss(animated: true, completion:nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func Leavesubmit(){
        
        let replacedFromDate = m_strFromDate?.replacingOccurrences(of: "/", with: "-")
        let replacedToDate = m_strToDate?.replacingOccurrences(of: "/", with: "-")
        
        let parameters="imei="+m_strenggimeino!+"&ver="+m_strappversion!+"&action=MobileDevice&subaction=updateavailtime&availtime=leave&leavetype="+m_strLeaveTypeID!+"&lat="+m_strlat+"&lon="+m_strlon+"&FromDate="+replacedFromDate!+"&ToDate="+replacedToDate!
        
        var reuest = URLRequest(url: URL(string: m_stripname!+"/smsreply.do")!)
        
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
