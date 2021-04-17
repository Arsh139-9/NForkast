//
//  AddedIngredientTBCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/20/21.
//

import UIKit

class AddedIngredientTBCell: UITableViewCell {

    @IBOutlet weak var ingredientNameLbl: UILabel!
    
    
    @IBOutlet weak var ingredientRateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
