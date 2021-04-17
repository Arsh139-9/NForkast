//
//  DailyInventoryDetailCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/11/21.
//

import UIKit

class DailyInventoryDetailCell: UITableViewCell {

    
    @IBOutlet weak var dIIngredientNameLbl: UILabel!
    
    @IBOutlet weak var checkUncheckImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
