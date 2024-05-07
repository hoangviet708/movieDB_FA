//
//  SearchViewController.swift
//  SmartMovie
//
//  Created by Hoang Viet on 03/04/2023.
//

import UIKit

final class SearchViewController: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var searchBarMovie: UISearchBar!

    private var presenter: SearchViewPresenterProtocol = SearchViewPresenter(model: SearchViewModel())

    private var timer: Timer?

    private var filteredMovies: [Movie] = []
    var isSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "ItemSearchViewCell", bundle: nil),
                                  forCellReuseIdentifier: "ItemSearchViewCell")
        contentTableView.separatorStyle = .none
        searchBarMovie.delegate = self
    }

    deinit {
        presenter.detachView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarMovie.showsCancelButton = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            view.endEditing(true)
            filteredMovies = []
            contentTableView.reloadData()
            self.searchBarMovie.showsCancelButton = false
        } else {
            timer?.invalidate()
            let queryString = searchText.replacingOccurrences(of: " ", with: "%20")
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                self?.showLoading()
                self?.presenter.getMoviesBySearch(with: queryString) { [weak self] in
                    self?.hideLoading()
                }
            })
        }

        if contentTableView.numberOfRows(inSection: 0) == 0 {
            let backgroundImage = UIImage(named: "no-results")
            let backgroundImageView = UIImageView(frame: contentTableView.frame)
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFit
            contentTableView.backgroundView = backgroundImageView
        } else {
            contentTableView.backgroundView = nil
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.searchBarMovie.showsCancelButton = false
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ItemSearchViewCell = tableView.dequeueReusableCell(
            withIdentifier: "ItemSearchViewCell") as? ItemSearchViewCell else { return ItemSearchViewCell()}
            let movie = filteredMovies[indexPath.row]
            cell.setData(data: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieDetailVC = UIStoryboard(name: "MovieDetail", bundle: nil)
            .instantiateViewController(withIdentifier: "MovieDetailViewController")
            as? MovieDetailViewController {
            let movie = filteredMovies[indexPath.row]
            movieDetailVC.movieId = movie.id
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}

extension SearchViewController: SearchViewViewProtocol {
    func displayMovies(movies: [Movie]) {
        filteredMovies = movies
        contentTableView.reloadData()
    }
}
