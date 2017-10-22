//
//  CompraTableViewCell.swift
//  DaniloMeire
//
//  Created by macos on 08/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit

class CompraTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblPreco: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
