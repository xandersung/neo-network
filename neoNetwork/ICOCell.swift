//
//  ICOCell.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/25/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import Foundation
import UIKit

class ICOCell : UICollectionViewCell {
    
    @IBOutlet weak var icoLabel: UILabel!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

    func displayICOLabel(title: String) {
        icoLabel.text = title
    }
    
}
