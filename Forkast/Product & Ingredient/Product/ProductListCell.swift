//
//  ProductListCell.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/15/21.
//

import UIKit

class ProductListCell: UITableViewCell {

    @IBOutlet weak var productImgView: UIImageView!
    
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var salesPrecentLbl: UILabel!
    
    @IBOutlet weak var salesPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
