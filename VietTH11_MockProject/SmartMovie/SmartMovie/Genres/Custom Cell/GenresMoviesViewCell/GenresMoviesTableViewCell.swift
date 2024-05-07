//
//  GenresMoviesTableViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import UIKit

final class GenresMoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieContentView: UIView!

    private var presenter: GenresMoviesViewPresenterProtocol = GenresMoviesViewPresenter(model: GenresMoviesViewModel())
    private var movie: Movie?
    private var isFavorite: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieContentView.backgroundColor = .secondarySystemBackground
        movieContentView.layer.cornerRadius = 10
        movieContentView.clipsToBounds = true
        movieImage.layer.cornerRadius = 10
        movieImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTapFavoriteBtn(_ sender: Any) {
        isFavorite = isFavorite == true ? false : true
        if isFavorite {
            starImage.image = UIImage(named: "star")
            if let id = movie?.id {
                let movie = FavoriteMovieObject(id: id, title: movie?.title ?? "")
               DatabaseManager.shared.saveMovieData(data: movie)
            }
        } else {
            starImage.image = UIImage(named: "star-non")
            if let id = movie?.id {
                DatabaseManager.shared.deleteMovieById(movieId: id)
            }
        }
    }

    func setData(data: Movie) {
        self.movie = data
        movieNameLabel.text = data.title
        movieDescription.text = data.overview
        if let path: String = data.posterPath {
            let url = URL(string: "\(ServerConstant.URLBase.baseURLImage)\(path)")
            movieImage.kf.setImage(with: url)
        }

        if let movieId = data.id {
           presenter.getMovieDetail(movieId: movieId, completion: { result in
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
