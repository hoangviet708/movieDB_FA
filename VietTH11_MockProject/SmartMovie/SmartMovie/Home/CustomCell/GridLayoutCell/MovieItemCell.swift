//
//  MovieItemCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 30/03/2023.
//

import UIKit
import Kingfisher

protocol MovieItemCellDelegate: AnyObject {
    func didSelectMovie(movie: Movie)
}

class MovieItemCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var contentItemView: UIView!
    @IBOutlet weak var starImage: UIImageView!

    private var isFavorite: Bool = false
    weak var delegate: MovieItemCellDelegate?
    private var presenter: HomeViewPresenterProtocol = HomeViewPresenter(model: HomeViewModel())
    private var movieItem: Movie?

    override func awakeFromNib() {
        super.awakeFromNib()
        contentItemView.layer.cornerRadius = 8
        contentItemView.clipsToBounds = true

        // Add gesture recognizer cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        self.contentView.addGestureRecognizer(tapGesture)
        }

    @objc func handleCellTap() {
        if let movieItem = movieItem {
            delegate?.didSelectMovie(movie: movieItem)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        starImage.image = nil
    }

    @IBAction func didTapFavoriteBtn(_ sender: Any) {
        isFavorite = isFavorite == true ? false : true
        if isFavorite {
            starImage.image = UIImage(named: "star")
            if let id = movieItem?.id {
                let movie = FavoriteMovieObject(id: id, title: movieItem?.title ?? "")
               DatabaseManager.shared.saveMovieData(data: movie)
            }
        } else {
            starImage.image = UIImage(named: "star-non")
            if let id = movieItem?.id {
                DatabaseManager.shared.deleteMovieById(movieId: id)
            }
        }
    }

    func setData(data: Movie) {
        self.movieItem = data
        movieNameLabel.text = data.title
        if let path: String = data.posterPath {
            let url = URL(string: "\(ServerConstant.URLBase.baseURLImage)\(path)")
            movieImage.kf.setImage(with: url)
        }
        if let movieId = data.id {
           presenter.getMovieDetail(movieId: movieId, completion: { [weak self] result in
               if let result = result {
                       if let minutes = result.runtime {
                           let movieDuration: String = convertMinutesToHoursAndMinutes(minutes: minutes)
                           DispatchQueue.main.async { [weak self] in
                               self?.movieDurationLabel.text = movieDuration
                           }
                       }
                }
            })

            isFavorite = DatabaseManager.shared.isMovieExist(id: movieId)
            if isFavorite {
                starImage.image = UIImage(named: "star")
            } else {
                starImage.image = UIImage(named: "star-non")
            }
        }
    }
}
