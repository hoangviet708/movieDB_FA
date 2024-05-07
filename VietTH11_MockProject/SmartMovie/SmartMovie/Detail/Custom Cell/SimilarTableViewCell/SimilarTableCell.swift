//
//  SimilarTableCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 07/04/2023.
//

import UIKit
import Kingfisher

final class SimilarTableCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieContentView: UIView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!

    private var presenter: MovieDetailViewPresenterProtocol = MovieDetailViewPresenter(model: MovieDetailViewModel())

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImage.layer.cornerRadius = 8
        movieImage.clipsToBounds = true
        movieContentView.layer.cornerRadius = 8
        movieContentView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData( data: Movie) {
        movieNameLabel.text = data.title
        if let rate = data.voteAverage {
            setRateStar(rate: rate)
        }
        if let path: String = data.backdropPath {
            let url = URL(string: "\(ServerConstant.URLBase.baseURLImage)\(path)")
            movieImage.kf.setImage(with: url)
        }
        if let movieId = data.id {
           presenter.getMovieDetail(movieId: movieId, completion: { [weak self] result in
               if let listGenres = result?.genres {
                   var temp: [String] = []
                   for item in listGenres {
                       if let name = item.name {
                           temp.append(name)
                       }
                   }
                   self?.movieGenres.text = temp.joined(separator: " | ")
                }
            })
        }
    }

    func setRateStar(rate: Double) {
        let arrStar: [UIImageView] = [starImage1, starImage2, starImage3, starImage4, starImage5]
        let rateInt: Int = Int(rate / 2)
        if rateInt <= 5 && rateInt >= 0 {
            for index in 0..<rateInt {
                arrStar[index].image = UIImage(named: "star")
            }
            for index in rateInt..<5 {
                arrStar[index].image = UIImage(named: "star-non")
            }
        }
    }
}
