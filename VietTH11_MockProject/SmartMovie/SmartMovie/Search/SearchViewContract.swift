//
//  SearchViewContract.swift
//  SmartMovie
//
//  Created by Hoang Viet on 03/04/2023.
//

import Foundation

protocol SearchViewContract {
    typealias Model = SearchViewModelProtocol
    typealias View = SearchViewViewProtocol
    typealias Presenter = SearchViewPresenterProtocol
}

protocol SearchViewModelProtocol {
    func requestMoviesBySearch(searchText: String, result: @escaping (Result<[Movie], APIError>) -> Void)
    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void)
}

protocol SearchViewViewProtocol: AnyObject {
    func displayMovies(movies: [Movie])
}

protocol SearchViewPresenterProtocol {
    func attach(view: SearchViewContract.View)
    func detachView()
    func getMoviesBySearch(with: String, completion: @escaping () -> Void)
    func getMovieDetail(movieId: Int, completion: @escaping (ResponseEntityMovieDetail?) -> Void)

}
