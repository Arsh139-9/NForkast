//
//  BiweekelyInventoryDetailCell.swift
//  Forkast
//
//  Created by Apple on 10/03/21.
//

import UIKit

class BiweekelyInventoryDetailCell: UITableViewCell {
    @IBOutlet weak var biWeeklyInventoryNameLbl: UILabel!

    @IBOutlet weak var biweeklyProfileImg: UIImageView!
    
    @IBOutlet weak var biIngredientNameLbl: UILabel!
    
    @IBOutlet weak var biCaseLbl: UILabel!
    
    @IBOutlet weak var biQuantityTF: UITextField!
    
    @IBOutlet weak var decreaseQuantityBtn: UIButton!
    
    @IBOutlet weak var increaseQuantityBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
