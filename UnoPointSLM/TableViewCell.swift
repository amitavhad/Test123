//
//  TableViewCell.swift
//  UnoPointSLM
//
//  Created by Amit A on 12/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
// for leave
    @IBOutlet weak var lblleavesummary: UILabel!
    
    
    // for Lead View
    
    
    @IBOutlet weak var uiviewleadview: UIView!
    @IBOutlet weak var lblleadid: UILabel!
    @IBOutlet weak var lblcustomername: UILabel!
    @IBOutlet weak var lblopportunitystatus: UILabel!
    @IBOutlet weak var lblcreatedby: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    
    
    
    // for lead details
    
    @IBOutlet weak var lblDetails: UILabel!
    
  
    // for Opp view
    
    
    @IBOutlet weak var uiviewoppview: UIView!
    
    @IBOutlet weak var lbloid: UILabel!
    
    @IBOutlet weak var lbloidcustomername: UILabel!
  
    @IBOutlet weak var lblinternalprogress: UILabel!
    @IBOutlet weak var lblexeternalprogress: UILabel!
    @IBOutlet weak var lblexecutivename: UILabel!
    
    
    // for Upcoming meeting view
     @IBOutlet weak var uiviewupcomingmeeting: UIView!
    
    @IBOutlet weak var lbloppid: UILabel!
    @IBOutlet weak var lblexecutivenames: UILabel!
    @IBOutlet weak var lblcustomernames: UILabel!
    @IBOutlet weak var lblscheduledate: UILabel!
    @IBOutlet weak var lblscheduletime: UILabel!
    
    // for upcoming meeting Details
    
    
    @IBOutlet weak var lblUpcomingmeetingDetails: UILabel!
    
    // for Upcoming meeting view
    @IBOutlet weak var uiviewcompletedgmeeting: UIView!
    
    @IBOutlet weak var lblcompletemeetingoppid: UILabel!
    @IBOutlet weak var lblcompletemeetingexecutivenames: UILabel!
    @IBOutlet weak var lblcompletemeetingcustomernames: UILabel!
    @IBOutlet weak var lblcompletemeetingmeetingdate: UILabel!
    @IBOutlet weak var lblcompletemeetingordervalue: UILabel!
    
    // for communication view
    @IBOutlet weak var uiviewcommunication: UIView!
    
    @IBOutlet weak var lblcommunicationoppid: UILabel!
    @IBOutlet weak var lblcommunicationID: UILabel!
    @IBOutlet weak var lblcommunicationBy: UILabel!
    @IBOutlet weak var lblcommunicationTo: UILabel!
  
    @IBOutlet weak var lblcommunicationcustname: UILabel!
    
    // for communcation details
    
    @IBOutlet weak var lblCommunicationDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
