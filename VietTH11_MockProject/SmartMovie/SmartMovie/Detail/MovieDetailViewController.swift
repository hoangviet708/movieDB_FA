//
//  MovieDetailViewController.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!

    // MARK: - Variables
    private var movieDetail: ResponseEntityMovieDetail?
    private var castMovie: [Cast] = []
    private var similarMovies: [Movie] = []
    private var heightConstraintDescription: NSLayoutConstraint?
    private var presenter: MovieDetailViewPresenterProtocol = MovieDetailViewPresenter(model: MovieDetailViewModel())
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        movieImage.layer.cornerRadius = 8
        movieImage.clipsToBounds = true
        setupTableView()
        presenter.attach(view: self)
        presenter.getMovieDetail(movieId: movieId)
        presenter.getMovieCast(movieId: movieId)
        presenter.getMoviesSimilar(movieId: movieId)
        setData()
        heightConstraintDescription = descriptionStackView.constraints.first(where: { $0.firstAttribute == .height })
        if descriptionLabel.maxNumberOfLines > 2 {
            seeMoreBtn.isHidden = true
        }
    }

    func setupTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "CastListTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "CastListTableViewCell")
        contentTableView.register(UINib(nibName: "SimilarTableCell", bundle: nil),
                                  forCellReuseIdentifier: "SimilarTableCell")
        contentTableView.register(UINib(nibName: "HeaderTableViewMovieDetail", bundle: nil),
                                  forHeaderFooterViewReuseIdentifier: "HeaderTableViewMovieDetail")

        if #available(iOS 15.0, *) {
            contentTableView.sectionHeaderTopPadding = 0
        }
        contentTableView.separatorStyle = .none
    }

    deinit {
        presenter.detachView()
    }

    @IBAction func handleSeeMore(_ sender: Any) {
        heightConstraintDescription?.isActive = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        seeMoreBtn.isHidden = true
    }

    func setData() {
        movieNameLabel.text =  movieDetail?.title
        descriptionLabel.text = movieDetail?.overview
        releaseDateLabel.text = movieDetail?.releaseDate

        if let rate = movieDetail?.voteAverage {
            setRateStar(rate: rate)
        }

        if let minutes = movieDetail?.runtime {
            let movieDuration: String = convertMinutesToHoursAndMinutes(minutes: minutes)
            durationLabel.text = movieDuration
        }

        if movieDetail?.spokenLanguages?.isEmpty == false {
            let language = movieDetail?.spokenLanguages?[0].name
            movieLanguageLabel.text = language
        } else {
            movieLanguageLabel.text = "English"
        }

        if let vote = movieDetail?.voteAverage {
            voteAverageLabel.text = String(format: "%.1f", vote)
        }
        if let path: String = movieDetail?.posterPath {
            let url = URL(string: "\(ServerConstant.URLBase.baseURLImage)\(path)")
            movieImage.kf.setImage(with: url)
        }

        if let listGenres = movieDetail?.genres {
            var temp: [String] = []
            for item in listGenres {
                if let name = item.name {
                    temp.append(name)
                }
            }
            genresLabel.text = temp.joined(separator: " | ")
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return similarMovies.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell: CastListTableViewCell = tableView
                .dequeueReusableCell(withIdentifier: "CastListTableViewCell")
                    as? CastListTableViewCell else { return CastListTableViewCell()}
            cell.setData(data: castMovie)
            return cell
        } else {
            guard let cell: SimilarTableCell = tableView
                .dequeueReusableCell(withIdentifier: "SimilarTableCell")
                    as? SimilarTableCell else { return SimilarTableCell()}
            let movie = similarMovies[indexPath.item]
            cell.setData(data: movie)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 400
        } else {
            return 240
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerView: HeaderTableViewMovieDetail = tableView
        .dequeueReusableHeaderFooterView(withIdentifier: "HeaderTableViewMovieDetail")
            as? HeaderTableViewMovieDetail else {
            return UIView()
        }

        if section == 0 {
            headerView.setData(title: "Cast")
        } else {
            headerView.setData(title: "Similar")
        }
            return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        heightConstraintDescription?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        seeMoreBtn.isHidden = false
    }
}

// MARK: - MovieDetailViewViewProtocol
extension MovieDetailViewController: MovieDetailViewViewProtocol {
    func displayMovieCast(data: [Cast]) {
        self.castMovie = data
        contentTableView.reloadData()
    }

    func displayMovieDetail(movieDetail: ResponseEntityMovieDetail) {
        self.movieDetail = movieDetail
        setData()
    }

    func displaySimilarMovies(data: [Movie]) {
        self.similarMovies = data
        contentTableView.reloadData()
    }
}
