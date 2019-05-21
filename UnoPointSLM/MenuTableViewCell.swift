//
//  MenuTableViewCell.swift
//  UnoPointSLM
//
//  Created by Amit A on 22/11/18.
//  Copyright © 2018 Amit A. All rights reserved.
//


import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var viewcell: UIView!
    
    
    @IBOutlet weak var cellimage: UIImageView!
    @IBOutlet weak var viewcellsubmenu: UIView!
    
    
    @IBOutlet weak var titleLabelforsubmenu: UILabel!
    
    // for lead sub menu
    @IBOutlet weak var viewcellleadsubmenu: UIView!
    
    @IBOutlet weak var titleLabelforleadsubmenu: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
