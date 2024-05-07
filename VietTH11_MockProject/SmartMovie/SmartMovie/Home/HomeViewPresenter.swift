//
//  HomeViewPresenter.swift
//  SmartMovie
//
//  Created by Hoang Viet on 29/03/2023.
//

import Foundation

enum ViewSection: Int {
    case popular
    case topRated
    case upcomming
    case nowPlaying
    case viewSectionCount
}

final class HomeViewPresenter {
    private weak var contentView: HomeViewContract.View?
    private var model: HomeViewContract.Model

    private var popularPageCount: Int = 1
    private var topRatePageCount: Int = 1
    private var upcommingPageCount: Int = 1
    private var nowPlayingPageCount: Int = 1

    private var popularMovies: [Movie] = []
    private var topRatedMovies: [Movie]  = []
    private var upcommingMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []

    private var categoriesOffset: [PageView: Double] = [:]

    init(model: HomeViewContract.Model) {
        self.model = model
    }

}

extension HomeViewPresenter: HomeViewPresenterProtocol {

    func detachView() {
        contentView = nil
    }

    func didTapChangeLayoutBtn() {
        NotificationCenter.default.post(name: NSNotification.Name("ChangeLayoutButtonTappedNotification"), object: nil)
    }

    func attach(view: HomeViewContract.View) {
        contentView = view
    }

    // MARK: - Request API
    func viewWillAppear(completion: @escaping (Int) -> Void) {
        var countFailedRequests: Int = 0
        let dispatchGroup = DispatchGroup()
        let categories = [ServerConstant.APIPath.popular,
                          ServerConstant.APIPath.topRated,
                          ServerConstant.APIPath.upComming,
                          ServerConstant.APIPath.nowPlaying]
        for category in categories {
            dispatchGroup.enter()
            model.getMoviesByCategory(category: category, page: 1) { [weak self] result in
                    switch result {
                    case .success(let movies):
                        switch category {
                        case ServerConstant.APIPath.popular:
                            self?.popularMovies = movies
                            dispatchGroup.leave()
                        case ServerConstant.APIPath.topRated:
                            self?.topRatedMovies = movies
                            dispatchGroup.leave()
                        case ServerConstant.APIPath.upComming:
                            self?.upcommingMovies = movies
                            dispatchGroup.leave()
                        case ServerConstant.APIPath.nowPlaying:
                            self?.nowPlayingMovies = movies
                            dispatchGroup.leave()
                        default:
                            break
                        }
                    case .failure(let error):
                        print("\(error)")
                        countFailedRequests += 1
                        dispatchGroup.leave()
                    }
                }
            }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.contentView?.displayAllMovies(popular: self?.popularMovies ?? [],
                                                topRated: self?.topRatedMovies ?? [],
                                                upcomming: self?.upcommingMovies ?? [],
                                                nowPlaying: self?.nowPlayingMovies ?? [])
            completion(countFailedRequests)
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

    func getPopularMovieList(completion: @escaping () -> Void) {
        popularPageCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.model.getMoviesByCategory(
                category: ServerConstant.APIPath.popular,
                page: self?.popularPageCount ?? 1) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.popularMovies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self?.contentView?.displayPopularMovies(self?.popularMovies ?? [])
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    func getTopRatedMovieList(completion: @escaping () -> Void) {
        topRatePageCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.model.getMoviesByCategory(
                category: ServerConstant.APIPath.topRated,
                page: self?.topRatePageCount ?? 1) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.topRatedMovies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self?.contentView?.displayTopRatedMovies(self?.topRatedMovies ?? [])
                    }
                    completion()
                case .failure(let error):
                    print("\(error)")
                    completion()
                }
            }
        }
    }

    func getUpcommingMovieList(completion: @escaping () -> Void) {
        upcommingPageCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.model.getMoviesByCategory(
                category: ServerConstant.APIPath.upComming,
                page: self?.upcommingPageCount ?? 1) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.upcommingMovies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self?.contentView?.displayUpcommingMovies(self?.upcommingMovies ?? [])
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    func getNowPlayingMovieList(completion: @escaping () -> Void) {
        nowPlayingPageCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.model.getMoviesByCategory(
                category: ServerConstant.APIPath.nowPlaying,
                page: self?.nowPlayingPageCount ?? 1) { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.nowPlayingMovies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self?.contentView?.displayNowPlayingMovies(self?.nowPlayingMovies ?? [])
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    func setOffsetOfCategory(category: PageView, yOffset: CGFloat) {
        categoriesOffset[category] = yOffset
    }

    func getOffsetOfCategory(category: PageView) -> CGFloat {
        return categoriesOffset[category] ?? 0
    }

    func refreshPage(currentPage: Int, completion: @escaping () -> Void) {
        switch PageView(rawValue: currentPage) {
        case .pageAllMovies:
            popularPageCount = 0
            topRatePageCount = 0
            upcommingPageCount = 0
            nowPlayingPageCount = 0
            popularMovies = []
            topRatedMovies = []
            upcommingMovies = []
            nowPlayingMovies = []
            categoriesOffset = [:]
            viewWillAppear(completion: {_ in })
            completion()
        case .pagePopular:
            popularPageCount = 0
            popularMovies = []
            getPopularMovieList(completion: {})
            completion()
        case .pageTopRated:
            topRatePageCount = 0
            topRatedMovies = []
            getTopRatedMovieList(completion: {})
            completion()
        case .pageUpcomming:
            upcommingPageCount = 0
            upcommingMovies = []
            getUpcommingMovieList(completion: {})
            completion()
        case .pageNowPlaying:
            nowPlayingPageCount = 0
            nowPlayingMovies = []
            getNowPlayingMovieList(completion: {})
            completion()
        default:
            completion()
            return
        }
    }

    // MARK: - CollectionView
    func numberOfSection(currentPage: Int) -> Int {
        switch PageView(rawValue: currentPage) {
        case .pageAllMovies:
            return ViewSection.viewSectionCount.rawValue
        default:
            return 1
        }
    }

    func numberOfSectionPage() -> Int {
        return PageView.pageViewCount.rawValue
    }

    func titleForHeaderInSection(currentPage: Int, section: Int) -> String? {
        let sectionTitles: [ViewSection: String] = [
               .popular: "Popular",
               .topRated: "Top Rated",
               .upcomming: "Up Comming",
               .nowPlaying: "Now Playing"
           ]
           guard let page = PageView(rawValue: currentPage) else {
               return nil
           }
           switch page {
           case .pageAllMovies:
               guard let viewSection = ViewSection(rawValue: section),
                     let sectionTitle = sectionTitles[viewSection] else {
                   return nil
               }
               return sectionTitle
           case .pagePopular:
               return "Popular"
           case .pageTopRated:
               return "Top Rated"
           case .pageUpcomming:
               return "Up Comming"
           case .pageNowPlaying:
               return "Now Playing"
           default:
               return nil
           }
    }
}
