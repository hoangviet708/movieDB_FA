//
//  MovieDetailViewPresenter.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import Foundation

final class MovieDetailViewPresenter {
    private weak var contentView: MovieDetailViewContract.View?
    private var model: MovieDetailViewContract.Model

    init(model: MovieDetailViewContract.Model) {
        self.model = model
    }
}

extension MovieDetailViewPresenter: MovieDetailViewPresenterProtocol {
    func attach(view: MovieDetailViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }

    func getMovieDetail(movieId: Int?) {
        if let movieId = movieId {
            model.getMovieDetail(movieId: movieId) { [weak self] result in
                switch result {
                case .success(let movieDetail):
                    DispatchQueue.main.async { [weak self] in
                        self?.contentView?.displayMovieDetail(movieDetail: movieDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func getMovieCast(movieId: Int?) {
        if let movieId = movieId {
            model.getMovieCast(movieId: movieId) { result in
                switch result {
                case .success(let data):
                    let castsList = data.cast
                    DispatchQueue.main.async { [weak self] in
                        self?.contentView?.displayMovieCast(data: castsList)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func getMoviesSimilar(movieId: Int?) {
        if let id = movieId {
            model.getMoviesSimilar(movieId: id) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async { [weak self] in
                        self?.contentView?.displaySimilarMovies(data: movies)
                    }
                case .failure(let error):
                    print("\(error)")
                }
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
