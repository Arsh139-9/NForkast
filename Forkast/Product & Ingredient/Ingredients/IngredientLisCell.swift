//
//  IngredientLisCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/17/21.
//

import UIKit

class IngredientLisCell: UITableViewCell {

    @IBOutlet weak var ingredientImgView: UIImageView!
    
    @IBOutlet weak var ingredientName: UILabel!
    
    @IBOutlet weak var vendorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
