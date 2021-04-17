//
//  BuildOrderDetailCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/24/21.
//

import UIKit

class BuildOrderDetailCell: UITableViewCell {

    @IBOutlet weak var buildOrderProductImgView: UIImageView!
    
    @IBOutlet weak var buildOrderProductNameLbl: UILabel!
    
    @IBOutlet weak var buildOrderIngredientNameLbl: UILabel!
    
    @IBOutlet weak var buildOrderCaseLbl: UILabel!
    
    @IBOutlet weak var buildOrderQuantityLbl: UILabel!
    
    @IBOutlet weak var buildOrderTheoreticalUsageLbl: UILabel!
    
    
    @IBOutlet weak var buildOrderQuantityTF: UITextField!
    
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
