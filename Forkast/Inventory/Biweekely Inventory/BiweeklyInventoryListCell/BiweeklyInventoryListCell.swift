//
//  BiweeklyInventoryListCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/10/21.
//

import UIKit

class BiweeklyInventoryListCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var nameBILbl: UILabel!
    
    @IBOutlet weak var dateTimeBILbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
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
