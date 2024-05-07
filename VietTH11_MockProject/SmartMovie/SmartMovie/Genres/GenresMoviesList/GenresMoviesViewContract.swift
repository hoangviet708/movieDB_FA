//
//  GenresMoviesViewContract.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import Foundation

protocol GenresMoviesViewContract {
    typealias Model = GenresMoviesViewModelProtocol
    typealias View = GenresMoviesViewViewProtocol
    typealias Presenter = GenresMoviesViewPresenterProtocol
}

protocol GenresMoviesViewModelProtocol {
    func requestMoviesByGenre(genreId: Int, result: @escaping (Result<[Movie], APIError>) -> Void)
    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void)
}

protocol GenresMoviesViewViewProtocol: AnyObject {
    func displayMoviesByGenre(moviesList: [Movie])
}

protocol GenresMoviesViewPresenterProtocol {
    func attach(view: GenresMoviesViewContract.View)
    func getMoviesByGenre(genreId: Int)
    func getMovieDetail(movieId: Int, completion: @escaping (ResponseEntityMovieDetail?) -> Void)
}
