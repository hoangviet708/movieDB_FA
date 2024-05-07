//
//  CategoryViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 10/04/2023.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var titleMenuItemLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            self.titleMenuItemLabel.textColor = isSelected ? .black : .lightGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleMenuItemLabel.textColor = .lightGray
    }
}
