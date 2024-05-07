//
//  HeaderSection.swift
//  SmartMovie
//
//  Created by Hoang Viet on 29/03/2023.
//

import UIKit

class HeaderSection: UICollectionReusableView {

    weak var delagate: HeaderSectionDelegate?
    var nameSection: ViewSection?

    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var sectionTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapSeeAllBtnInGrid(_ sender: Any) {
        if let nameSection = nameSection {
            delagate?.didTapSeeAllBtn(nameSection: nameSection)
        }
    }

    func hiddenSeeAllBtn() {
        seeAllBtn.isHidden = true
    }

    func showSeeAllBtn() {
        seeAllBtn.isHidden = false
    }
}
