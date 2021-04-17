//
//  NotificationTBCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/26/21.
//

import UIKit

class NotificationTBCell: UITableViewCell {

    @IBOutlet weak var notificationImgView: UIImageView!
    
    @IBOutlet weak var notificationNameLbl: UILabel!
    
    @IBOutlet weak var notificationDescriptionLbl: UILabel!
    
    @IBOutlet weak var notificationDateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
