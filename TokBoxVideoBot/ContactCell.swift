//
//  ContactCell.swift
//  TokBoxVideoBot
//
//  Created by Deblina Das on 18/04/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet var playerName: UILabel!
    
    func configureCell(name: String) {
        playerName.text = name
    }
}
