//
//  PageCollectionViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 29/03/2023.
//

import UIKit

enum PageView: Int {
    case pageAllMovies
    case pagePopular
    case pageTopRated
    case pageUpcomming
    case pageNowPlaying
    case pageViewCount
}

protocol PageCollectionViewCellDelegate: AnyObject {
    func scrollToPageCollectionViewCell(at index: Int)
    func didSelectMovie(movieSelected: Movie)
}

class PageCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var contentTableView: UITableView!

    // MARK: - Variables
    weak var delegate: PageCollectionViewCellDelegate?
    var loadmoreViewGridLayout: ActivityLoadingView?
    var currentPage: Int = 0
    var listPopularMovies: [Movie] = []
    var listTopRatedMovies: [Movie] = []
    var listUpcommingMovies: [Movie] = []
    var listNowPlayingMovies: [Movie] = []
    var presenter: HomeViewPresenterProtocol = HomeViewPresenter(model: HomeViewModel())

    // MARK: - Configure initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        setupCollectionView()
        configureLayout()
        configureRefreshControl()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setPresenter(data: HomeViewPresenterProtocol) {
        self.presenter = data
    }

    func setupData(currentPage: Int, popular: [Movie], topRated: [Movie], upcomming: [Movie], nowPlaying: [Movie] ) {
        listPopularMovies = popular
        listTopRatedMovies = topRated
        listUpcommingMovies = upcomming
        listNowPlayingMovies = nowPlaying
        self.currentPage = currentPage
        if let category = PageView(rawValue: currentPage) {
            let savedOffsetY: CGFloat = presenter.getOffsetOfCategory(category: category)
            contentCollectionView.setContentOffset(CGPoint(x: 0, y: savedOffsetY), animated: false)
            contentTableView.setContentOffset(CGPoint(x: 0, y: savedOffsetY), animated: false)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentCollectionView.contentOffset = CGPoint()
        contentTableView.contentOffset = CGPoint()
    }

    func configureLayout() {
        let isGridLayout: Bool =  UserDefaults.standard.bool(forKey: "isGridLayout")
        if isGridLayout == true {
            contentCollectionView.isHidden = false
            contentTableView.isHidden = true
        } else {
            contentCollectionView.isHidden = true
            contentTableView.isHidden = false
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleChangeLayoutButtonTapped),
                                               name: NSNotification.Name("ChangeLayoutButtonTappedNotification"),
                                               object: nil)
    }

    // MARK: - Configure CollectionView
    func setupCollectionView() {
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        contentCollectionView.collectionViewLayout = layout
        contentCollectionView.register(UINib(nibName: "HeaderSection", bundle: nil),
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: "HeaderSection")
        contentCollectionView.register(UINib(nibName: "MovieItemCell", bundle: nil),
                                       forCellWithReuseIdentifier: "MovieItemCell")
        contentCollectionView.register(UINib(nibName: "ActivityLoadingView", bundle: nil),
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                       withReuseIdentifier: "ActivityLoadingView")
    }

    // MARK: - Configure TableView
    func setupTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "MovieTableViewCell")
        contentTableView.register(UINib(nibName: "HeaderTableView", bundle: nil),
                                  forHeaderFooterViewReuseIdentifier: "HeaderTableView")
        contentTableView.separatorStyle = .none

        // LoadingView of tableViewLayout
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: contentTableView.bounds.width, height: CGFloat(44))
        contentTableView.tableFooterView = spinner
        contentTableView.tableFooterView?.isHidden = false

    }

    // MARK: - Pull to refresh
    func configureRefreshControl() {
        contentCollectionView.refreshControl = UIRefreshControl()
        contentCollectionView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControlGridLayout),
                                          for: .valueChanged)
        contentTableView.refreshControl = UIRefreshControl()
        contentTableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControlRowLayout),
                                          for: .valueChanged)
    }

    @objc func handleRefreshControlGridLayout() {
        presenter.refreshPage(currentPage: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.contentCollectionView.refreshControl?.endRefreshing()
            }
        }
    }

    @objc func handleRefreshControlRowLayout() {
        presenter.refreshPage(currentPage: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.contentTableView.refreshControl?.endRefreshing()
            }
        }
    }

    // MARK: - Save contentOffSet attribute
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let category = PageView(rawValue: currentPage) {
            presenter.setOffsetOfCategory(category: category, yOffset: scrollView.contentOffset.y)
        }
    }

    // MARK: - Handling layout changes
    @objc func handleChangeLayoutButtonTapped() {
        let isGridLayout: Bool =  UserDefaults.standard.bool(forKey: "isGridLayout")
        if isGridLayout == true {
            UIView.transition(from: contentTableView, to: contentCollectionView,
                              duration: 0.5, options: [.transitionFlipFromRight,
                                .curveEaseOut, .showHideTransitionViews], completion: nil)
            contentCollectionView.reloadData()
        } else {
            UIView.transition(from: contentCollectionView, to: contentTableView,
                              duration: 0.5, options: [.transitionFlipFromLeft,
                                .curveEaseOut, .showHideTransitionViews], completion: nil)
            contentTableView.reloadData()
        }
    }
}

// MARK: - HeaderSectionDelegate
extension PageCollectionViewCell: HeaderSectionDelegate {
    func didTapSeeAllBtn(nameSection: ViewSection) {
        switch nameSection {
        case .popular:
            delegate?.scrollToPageCollectionViewCell(at: PageView.pagePopular.rawValue)
        case .topRated:
            delegate?.scrollToPageCollectionViewCell(at: PageView.pageTopRated.rawValue)
        case .upcomming:
            delegate?.scrollToPageCollectionViewCell(at: PageView.pageUpcomming.rawValue)
        case .nowPlaying:
            delegate?.scrollToPageCollectionViewCell(at: PageView.pageNowPlaying.rawValue)
        default:
            delegate?.scrollToPageCollectionViewCell(at: 0)
        }
    }
}

// MARK: - MovieItemCellDelegate
extension PageCollectionViewCell: MovieItemCellDelegate {
    func didSelectMovie(movie: Movie) {
        delegate?.didSelectMovie(movieSelected: movie)
    }
}

extension PageCollectionViewCell {
     func getMovieForIndexPath(for indexPath: IndexPath) -> Movie? {
        switch PageView(rawValue: currentPage) {
        case .pageAllMovies:
            return getMovieForAllMoviesPage(for: indexPath)
        case .pagePopular:
            return listPopularMovies[indexPath.row]
        case .pageTopRated:
            return listTopRatedMovies[indexPath.row]
        case .pageUpcomming:
            return listUpcommingMovies[indexPath.row]
        case .pageNowPlaying:
            return listNowPlayingMovies[indexPath.row]
        default:
            return nil
        }
    }

     func getMovieForAllMoviesPage(for indexPath: IndexPath) -> Movie? {
        guard let viewSection = ViewSection(rawValue: indexPath.section) else { return nil }
        switch viewSection {
        case .popular:
            return listPopularMovies[indexPath.row]
        case .topRated:
            return listTopRatedMovies[indexPath.row]
        case .upcomming:
            return listUpcommingMovies[indexPath.row]
        case .nowPlaying:
            return listNowPlayingMovies[indexPath.row]
        default:
            return nil
        }
    }
}
