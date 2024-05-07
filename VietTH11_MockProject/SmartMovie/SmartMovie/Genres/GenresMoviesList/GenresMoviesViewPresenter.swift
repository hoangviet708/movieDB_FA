//
//  GenresMoviesViewPresenter.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import Foundation

final class GenresMoviesViewPresenter {
    private weak var contentView: GenresMoviesViewContract.View?
    private var model: GenresMoviesViewContract.Model

    init(model: GenresMoviesViewContract.Model) {
        self.model = model
    }
}

extension GenresMoviesViewPresenter: GenresMoviesViewPresenterProtocol {

    func attach(view: GenresMoviesViewContract.View) {
        contentView = view
    }

    func getMoviesByGenre(genreId: Int) {
        model.requestMoviesByGenre(genreId: genreId) { [weak self] result in
            switch result {
            case .success(let data):
                self?.contentView?.displayMoviesByGenre(moviesList: data)
            case .failure(let error):
                print(error)
            }
        }
    }

    func getMovieDetail(movieId: Int, completion: @escaping (ResponseEntityMovieDetail?) -> Void) {
        model.getMovieDetail(movieId: movieId) { result in
            switch result {
            case .success(let movie):
                completion(movie)
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
}
