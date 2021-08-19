//
//  SearchTableViewCell.swift
//  MyApp
//
//  Created by 武井優弥 on 2020/07/14.
//  Copyright © 2020 euyah.com. All rights reserved.
//

import UIKit


protocol SearchTableViewCellDelegate {
}



class SearchTableViewCell: UITableViewCell {

    var delegate: SearchTableViewCellDelegate?
    
    @IBOutlet var directionLabel:UILabel!
    @IBOutlet var userimageView2:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
