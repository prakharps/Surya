//
//  TableViewCell.swift
//  surya
//
//  Created by Prakhar Srivastava on 04/03/19.
//  Copyright © 2019 Prakhar Srivastava. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //@IBOutlet weak var image: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
