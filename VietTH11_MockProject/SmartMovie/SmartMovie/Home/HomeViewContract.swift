//
//  HomeViewContract.swift
//  SmartMovie
//
//  Created by Hoang Viet on 29/03/2023.
//

import Foundation

protocol HomeViewContract {
    typealias Model = HomeViewModelProtocol
    typealias View = HomeViewViewProtocol
    typealias Presenter = HomeViewPresenterProtocol
}

protocol HomeViewModelProtocol {
    func getMoviesByCategory(category: String, page: Int, result: @escaping (Result<[Movie], APIError>) -> Void)
    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void)
}

protocol HomeViewViewProtocol: AnyObject {
    func displayPopularMovies(_ listMovies: [Movie])
    func displayTopRatedMovies(_ listMovies: [Movie])
    func displayUpcommingMovies(_ listMovies: [Movie])
    func displayNowPlayingMovies(_ listMovies: [Movie])
    func displayAllMovies(popular: [Movie], topRated: [Movie], upcomming: [Movie], nowPlaying: [Movie])
}

protocol HomeViewPresenterProtocol {
    func attach(view: HomeViewContract.View)
    func detachView()
    func viewWillAppear(completion: @escaping (Int) -> Void)
    func numberOfSection(currentPage: Int) -> Int
    func numberOfSectionPage() -> Int
    func titleForHeaderInSection(currentPage: Int, section: Int) -> String?
    func getMovieDetail(movieId: Int, completion: @escaping (ResponseEntityMovieDetail?) -> Void)
    func didTapChangeLayoutBtn()
    func getPopularMovieList(completion: @escaping () -> Void)
    func getTopRatedMovieList(completion: @escaping () -> Void)
    func getUpcommingMovieList(completion: @escaping () -> Void)
    func getNowPlayingMovieList(completion: @escaping () -> Void)
    func setOffsetOfCategory(category: PageView, yOffset: CGFloat)
    func getOffsetOfCategory(category: PageView) -> CGFloat
    func refreshPage(currentPage: Int, completion: @escaping () -> Void)
}
