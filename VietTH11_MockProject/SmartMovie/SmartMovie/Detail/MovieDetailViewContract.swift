//
//  MovieDetailViewContract.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import Foundation

protocol MovieDetailViewContract {
    typealias Model = MovieDetailViewModelProtocol
    typealias View = MovieDetailViewViewProtocol
    typealias Presenter = MovieDetailViewPresenterProtocol
}

protocol MovieDetailViewModelProtocol {
    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void)
    func getMovieCast(movieId: Int, result: @escaping (Result<ResponseEntityMovieCast, APIError>) -> Void)
    func getMoviesSimilar(movieId: Int, result: @escaping (Result<[Movie], APIError>) -> Void)
}

protocol MovieDetailViewViewProtocol: AnyObject {
    func displayMovieDetail(movieDetail: ResponseEntityMovieDetail)
    func displayMovieCast(data: [Cast])
    func displaySimilarMovies(data: [Movie])
}

protocol MovieDetailViewPresenterProtocol {
    func attach(view: MovieDetailViewContract.View)
    func detachView()
    func getMovieDetail(movieId: Int?)
    func getMovieCast(movieId: Int?)
    func getMoviesSimilar(movieId: Int?)
    func getMovieDetail(movieId: Int, completion: @escaping (ResponseEntityMovieDetail?) -> Void)
}
