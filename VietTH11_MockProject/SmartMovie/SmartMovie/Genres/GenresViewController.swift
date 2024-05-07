//
//  GenresViewController.swift
//  SmartMovie
//
//  Created by Hoang Viet on 04/04/2023.
//

import UIKit

final class GenresViewController: UIViewController {

    @IBOutlet weak var contentTableView: UITableView!

    private var presenter: GenresViewPresenterProtocol = GenresViewPresenter(model: GenresViewModel())
    private var genresList: [Genre] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "GenresTableViewCell")
        contentTableView.separatorStyle = .none
        presenter.getGenresDetail()
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter.detachView()
    }
}

extension GenresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GenresTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell")
                as? GenresTableViewCell else { return GenresTableViewCell()}
        let genre = genresList[indexPath.item]
        cell.setData(data: genre)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = genresList[indexPath.item]
        if let genresMoviesVC = UIStoryboard(name: "GenresMoviesList", bundle: nil)
            .instantiateViewController(withIdentifier: "GenresMoviesViewController") as? GenresMoviesViewController {
            genresMoviesVC.genreId = genre.id
            genresMoviesVC.genreTitle = genre.name
            navigationController?.pushViewController(genresMoviesVC, animated: true)
        }
    }
}

extension GenresViewController: GenresViewViewProtocol {
    func displayGenres(genres: [Genre]) {
        genresList = genres
        contentTableView.reloadData()
    }
}
