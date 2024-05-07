//
//  GenresViewContract.swift
//  SmartMovie
//
//  Created by Hoang Viet on 04/04/2023.
//

import Foundation

protocol GenresViewContract {
    typealias Model = GenresViewModelProtocol
    typealias View = GenresViewViewProtocol
    typealias Presenter = GenresViewPresenterProtocol
}

protocol GenresViewModelProtocol {
    func requestGenres(result: @escaping (Result<ResponseGenresEntity, APIError>) -> Void)
    func requestMoviesByGenre(genreId: Int, result: @escaping (Result<[Movie], APIError>) -> Void)
}

protocol GenresViewViewProtocol: AnyObject {
    func displayGenres(genres: [Genre])
}

protocol GenresViewPresenterProtocol {
    func getGenresDetail()
    func attach(view: GenresViewContract.View)
    func detachView()
    func getMoviesByGenre(genreId: Int)
}
