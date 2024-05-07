//
//  CastCollectionViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import UIKit

final class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castView: UIView!
    private var castInfo: Cast?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        castImage.layer.cornerRadius = 8
        castImage.clipsToBounds = true
        castView.layer.cornerRadius = 8
        castView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        castImage.image = UIImage(named: "profile-default")
    }

    func setData(data: Cast) {
        castInfo = data
        castNameLabel.text = data.originalName
        if let path: String = castInfo?.profilePath {
            let url = URL(string: "\(ServerConstant.URLBase.baseURLImage)\(path)")
            castImage.kf.setImage(with: url)
        }
    }
}
