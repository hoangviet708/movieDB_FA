//
//  HeaderTableViewMovieDetail.swift
//  SmartMovie
//
//  Created by Hoang Viet on 07/04/2023.
//

import UIKit

final class HeaderTableViewMovieDetail: UITableViewHeaderFooterView {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(title: String) {
        nameLabel.text = title
    }

}
