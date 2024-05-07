//
//  ExtensionPageCollectionViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 12/04/2023.
//

import Foundation
import UIKit

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PageCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSection(currentPage: currentPage)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let movieLists: [ViewSection: [Movie]] = [
            .popular: listPopularMovies,
            .topRated: listTopRatedMovies,
            .upcomming: listUpcommingMovies,
            .nowPlaying: listNowPlayingMovies
        ]

        guard let page = PageView(rawValue: currentPage) else {
            return 0
        }

        switch page {
        case .pageAllMovies:
            guard let viewSection = ViewSection(rawValue: section),
                  let movieList = movieLists[viewSection] else {
                return 0
            }
            return min(movieList.count, 4)
        case .pagePopular:
            return listPopularMovies.count
        case .pageTopRated:
            return listTopRatedMovies.count
        case .pageUpcomming:
            return listUpcommingMovies.count
        case .pageNowPlaying:
            return listNowPlayingMovies.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MovieItemCell", for: indexPath)
                as? MovieItemCell else {return UICollectionViewCell()}
        guard let movie = getMovieForIndexPath(for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setData(data: movie)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "HeaderSection",
                for: indexPath) as? HeaderSection else {
                return HeaderSection()
            }

            let title = presenter.titleForHeaderInSection(currentPage: currentPage, section: indexPath.section)
            headerView.sectionTitle.text = title
            headerView.nameSection = ViewSection(rawValue: indexPath.section)
            headerView.delagate = self
            if PageView(rawValue: currentPage) == .pageAllMovies {
                headerView.showSeeAllBtn()
            } else {
                headerView.hiddenSeeAllBtn()
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "ActivityLoadingView",
                for: indexPath) as? ActivityLoadingView else {
                return ActivityLoadingView()
            }
            self.loadmoreViewGridLayout = footerView
            return footerView
        default:
            fatalError("Unexpected element kind: \(kind)")
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        switch PageView(rawValue: currentPage) {
        case .pageAllMovies:
                return
        case .pagePopular:
            let lastItem = collectionView.numberOfItems(inSection: 0) - 1
                if indexPath.item == lastItem {
                    loadmoreViewGridLayout?.isHidden = false
                    loadmoreViewGridLayout?.activityLoading.startAnimating()
                    presenter.getPopularMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.loadmoreViewGridLayout?.isHidden = true
                        }
                    }
                }
        case .pageTopRated:
            let lastItem = collectionView.numberOfItems(inSection: 0) - 1
                if indexPath.item == lastItem {
                    loadmoreViewGridLayout?.isHidden = false
                    loadmoreViewGridLayout?.activityLoading.startAnimating()
                    presenter.getTopRatedMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.loadmoreViewGridLayout?.isHidden = true
                        }
                    }
                }
        case .pageUpcomming:
            let lastItem = collectionView.numberOfItems(inSection: 0) - 1
                if indexPath.item == lastItem {
                    loadmoreViewGridLayout?.isHidden = false
                    loadmoreViewGridLayout?.activityLoading.startAnimating()
                    presenter.getUpcommingMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.loadmoreViewGridLayout?.isHidden = true
                        }
                    }
                }
        case .pageNowPlaying:
            let lastItem = collectionView.numberOfItems(inSection: 0) - 1
                if indexPath.item == lastItem {
                    loadmoreViewGridLayout?.isHidden = false
                    loadmoreViewGridLayout?.activityLoading.startAnimating()
                    presenter.getNowPlayingMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.loadmoreViewGridLayout?.isHidden = true
                        }
                    }
                }
        default:
            return
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if listPopularMovies.isEmpty &&
            listTopRatedMovies.isEmpty &&
            listUpcommingMovies.isEmpty &&
            listNowPlayingMovies.isEmpty {
            return .zero
        }

        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if PageView(rawValue: currentPage) == .pageAllMovies {
            return .zero
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = UIScreen.main.bounds.width - 3 * 16
        return CGSize(width: width / 2, height: 320 )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
extension PageCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSection(currentPage: currentPage)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let movieLists: [ViewSection: [Movie]] = [
            .popular: listPopularMovies,
            .topRated: listTopRatedMovies,
            .upcomming: listUpcommingMovies,
            .nowPlaying: listNowPlayingMovies
        ]

        guard let page = PageView(rawValue: currentPage) else {
            return 0
        }

        switch page {
        case .pageAllMovies:
            guard let viewSection = ViewSection(rawValue: section),
                  let movieList = movieLists[viewSection] else {
                return 0
            }
            return min(movieList.count, 4)
        case .pagePopular:
            return listPopularMovies.count
        case .pageTopRated:
            return listTopRatedMovies.count
        case .pageUpcomming:
            return listUpcommingMovies.count
        case .pageNowPlaying:
            return listNowPlayingMovies.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")
                as? MovieTableViewCell else {return MovieTableViewCell()}
        guard let movie = getMovieForIndexPath(for: indexPath) else {
            return MovieTableViewCell()
        }
        cell.setData(data: movie)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView: HeaderTableView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "HeaderTableView") as? HeaderTableView else {
            return UIView()
        }
        let title = presenter.titleForHeaderInSection(currentPage: currentPage, section: section)
        headerView.nameCategoryLabel.text = title
        headerView.nameSection = ViewSection(rawValue: section)
        headerView.delegate = self

        if PageView(rawValue: currentPage) == .pageAllMovies {
            headerView.showSeeAllBtn()
        } else {
            headerView.hiddenSeeAllBtn()
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch PageView(rawValue: currentPage) {
        case .pageAllMovies:
                return
        case .pagePopular:
            let lastItem = tableView.numberOfRows(inSection: 0) - 1
                if indexPath.row == lastItem {
                    contentTableView.tableFooterView?.isHidden = false
                    presenter.getPopularMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.contentTableView.tableFooterView?.isHidden = true
                        }
                    }
                }
        case .pageTopRated:
            let lastItem = tableView.numberOfRows(inSection: 0) - 1
                if indexPath.item == lastItem {
                    contentTableView.tableFooterView?.isHidden = false
                    presenter.getTopRatedMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.contentTableView.tableFooterView?.isHidden = true
                        }
                    }
                }
        case .pageUpcomming:
            let lastItem = tableView.numberOfRows(inSection: 0) - 1
                if indexPath.item == lastItem {
                    contentTableView.tableFooterView?.isHidden = false
                    presenter.getUpcommingMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.contentTableView.tableFooterView?.isHidden = true
                        }
                    }
                }
        case .pageNowPlaying:
            let lastItem = tableView.numberOfRows(inSection: 0) - 1
                if indexPath.item == lastItem {
                    contentTableView.tableFooterView?.isHidden = false
                    presenter.getNowPlayingMovieList { [weak self] in
                        DispatchQueue.main.async {
                            self?.contentTableView.tableFooterView?.isHidden = true
                        }
                    }
                }
        default:
            return
        }
    }
}
