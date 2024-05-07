//
//  GenresViewPresenter.swift
//  SmartMovie
//
//  Created by Hoang Viet on 04/04/2023.
//

import Foundation

final class GenresViewPresenter {
    private weak var contentView: GenresViewContract.View?
    private var model: GenresViewContract.Model

    init(model: GenresViewContract.Model) {
        self.model = model
    }
}

extension GenresViewPresenter: GenresViewPresenterProtocol {
    func attach(view: GenresViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }

    func getGenresDetail() {
        model.requestGenres { result in
            switch result {
            case .success(let data):
                if let genres = data.genres {
                    DispatchQueue.main.async { [ weak self] in
                        self?.contentView?.displayGenres(genres: genres)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func getMoviesByGenre(genreId: Int) {
        model.requestMoviesByGenre(genreId: genreId) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
