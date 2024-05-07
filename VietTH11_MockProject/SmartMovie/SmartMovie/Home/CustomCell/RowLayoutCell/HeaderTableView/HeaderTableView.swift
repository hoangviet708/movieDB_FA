//
//  HeaderTableView.swift
//  SmartMovie
//
//  Created by Hoang Viet on 01/04/2023.
//

import UIKit

protocol HeaderSectionDelegate: AnyObject {
    func didTapSeeAllBtn(nameSection: ViewSection)
}

class HeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var nameCategoryLabel: UILabel!

    @IBOutlet weak var seeAllBtn: UIButton!

    weak var delegate: HeaderSectionDelegate?

    var nameSection: ViewSection?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapSeeAllBtn(_ sender: Any) {
        if let nameSection = nameSection {
            delegate?.didTapSeeAllBtn(nameSection: nameSection)
        }
    }

    func hiddenSeeAllBtn() {
        seeAllBtn.isHidden = true
    }

    func showSeeAllBtn() {
        seeAllBtn.isHidden = false
    }
}
