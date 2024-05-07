//
//  SearchViewPresenter.swift
//  SmartMovie
//
//  Created by Hoang Viet on 03/04/2023.
//

import Foundation

final class SearchViewPresenter {
    private weak var contentView: SearchViewContract.View?
    private var model: SearchViewContract.Model

    init(model: SearchViewContract.Model) {
        self.model = model
    }
}

extension SearchViewPresenter: SearchViewPresenterProtocol {
    func getMoviesBySearch(with: String, completion: @escaping () -> Void) {
        model.requestMoviesBySearch(searchText: with) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.contentView?.displayMovies(movies: movies)
                    completion()
                }
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }

    func attach(view: SearchViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
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
