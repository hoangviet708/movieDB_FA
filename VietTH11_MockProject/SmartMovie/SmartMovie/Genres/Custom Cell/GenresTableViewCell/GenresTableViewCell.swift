//
//  GenresTableViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 04/04/2023.
//

import UIKit

final class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreContentView: UIView!

    let genreImageMap: [Int: String] = [
        01: "default-genre",
        28: "action",
        12: "adventure",
        16: "animation",
        35: "comedy",
        80: "crime",
        99: "documentary",
        18: "drama",
        10751: "family",
        14: "fantasy",
        36: "history",
        27: "horror",
        10402: "music",
        9648: "mystery",
        10749: "romance",
        878: "science",
        10770: "tvmovie",
        53: "thriller",
        10752: "war",
        37: "western"
    ]

    private var idDefault: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        genreContentView.layer.cornerRadius = 10
        genreContentView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: Genre) {
        genreNameLabel.text = data.name
        guard let nameimg: String = genreImageMap[data.id ?? idDefault] else {
            genreImage.image = UIImage(named: "default-genre")
            return
        }
        genreImage.image = UIImage(named: nameimg)
    }
}
