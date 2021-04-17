//
//  DailyInventoryListTBCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit

class DailyInventoryListTBCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var nameDILbl: UILabel!
    
    @IBOutlet weak var dateTimeDILbl: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var editBtnImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
