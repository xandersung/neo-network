//
//  NEP5Cell.swift
//  neoNetwork
//
//  Created by Alexander Sung on 1/25/18.
//  Copyright © 2018 Alexander Sung. All rights reserved.
//

import Foundation
import UIKit

class NEP5Cell : UICollectionViewCell {
    
    @IBOutlet weak var nep5Label: UILabel!
    @IBOutlet weak var cellDividerView: UIView!
    @IBOutlet weak var nep5Image: UIImageView!
    @IBOutlet weak var nep5CurrencyLabel: UILabel!
    @IBOutlet weak var nep5DeltaLabel: UILabel!
    
    override func layoutSubviews() {
    }
    
    func displayNEP5Label(title: String) {
        nep5Label.text = title
    }
    
    func updateNEP5Price(currency: String, delta: String) {
        nep5CurrencyLabel.text = currency
        nep5DeltaLabel.text = delta
        if delta[delta.startIndex] == "-" {
            nep5DeltaLabel.textColor = UIColor.red
        } else {
            nep5DeltaLabel.textColor = UIColor.green
        }
    }
    
    func displayNEP5Image(image: UIImage) {
        nep5Image.image = image
    }
    
}
