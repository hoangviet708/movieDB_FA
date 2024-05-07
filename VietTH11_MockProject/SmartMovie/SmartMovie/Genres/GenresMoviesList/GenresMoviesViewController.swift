//
//  GenresMoviesViewController.swift
//  SmartMovie
//
//  Created by Hoang Viet on 04/04/2023.
//

import UIKit

final class GenresMoviesViewController: UIViewController {

    var genreId: Int?
    var genreTitle: String?
    private var genreMoviesList: [Movie] = []
    private var presenter: GenresMoviesViewPresenterProtocol = GenresMoviesViewPresenter(model: GenresMoviesViewModel())

    @IBOutlet weak var contentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "GenresMoviesTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "GenresMoviesTableViewCell")
        contentTableView.separatorStyle = .none
        title = genreTitle
        presenter.attach(view: self)
        if let genreId = genreId {
            presenter.getMoviesByGenre(genreId: genreId)
        }
    }
}

extension GenresMoviesViewController: GenresMoviesViewViewProtocol {
    func displayMoviesByGenre(moviesList: [Movie]) {
        genreMoviesList = moviesList
        contentTableView.reloadData()
    }
}

extension GenresMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreMoviesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GenresMoviesTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "GenresMoviesTableViewCell")
                as? GenresMoviesTableViewCell else { return GenresMoviesTableViewCell()}
        let movie = genreMoviesList[indexPath.item]
        cell.setData(data: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieDetailVC = UIStoryboard(name: "MovieDetail", bundle: nil)
            .instantiateViewController(withIdentifier: "MovieDetailViewController")
            as? MovieDetailViewController {
            let movie = genreMoviesList[indexPath.item]
            movieDetailVC.movieId = movie.id
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}
