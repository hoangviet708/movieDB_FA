//
//  ViewController.swift
//  SmartMovie
//
//  Created by KhanhVD1.APL on 3/28/23.
//

import UIKit

final class HomeViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var collectionViewContainer: UICollectionView!
    @IBOutlet weak var changeLayoutBtn: UIBarButtonItem!
    @IBOutlet weak var movieBtn: UIButton!
    @IBOutlet weak var popularBtn: UIButton!
    @IBOutlet weak var topRatedBtn: UIButton!
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var nowPlayingBtn: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categorySubStackView: UIStackView!

    // MARK: - Variables
    private var categoryMenuBar = CategoryMenuBar()
    private var presenter: HomeViewPresenterProtocol = HomeViewPresenter(model: HomeViewModel())
    var listPopularMovies: [Movie] = []
    var listTopRatedMovies: [Movie] = []
    var listUpcommingMovies: [Movie] = []
    var listNowPlayingMovies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupCategoryTabBar()
        UserDefaults.standard.set(true, forKey: "isGridLayout")
    }

    // MARK: Setup view
    func setupCategoryTabBar() {
        self.view.addSubview(categoryMenuBar)
        categoryMenuBar.delegate = self
        categoryMenuBar.translatesAutoresizingMaskIntoConstraints = false
        categoryMenuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 5
        categoryMenuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        categoryMenuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        categoryMenuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        categoryMenuBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.attach(view: self)
        showLoading()
        presenter.viewWillAppear { [weak self] countFailed in
                if countFailed == 4 {
                    let reloadDataAction = UIAlertAction(title: "Reload", style: .default) { _ in
                        self?.viewWillAppear(animated)
                    }
                    self?.displayAlert(message: "Load Data Failed", actions: [reloadDataAction])
                }
                self?.hideLoading()
            }
        collectionViewContainer.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.detachView()
        hideLoading()
    }

    func setupCollectionView() {
        collectionViewContainer.delegate = self
        collectionViewContainer.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewContainer.collectionViewLayout = layout
        collectionViewContainer.isPagingEnabled = true
        collectionViewContainer.contentInsetAdjustmentBehavior = .never
        collectionViewContainer.isPrefetchingEnabled = false
        collectionViewContainer.register(UINib(nibName: "PageCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "PageCollectionViewCell")
    }

    @IBAction func didTapChangeLayoutBtn(_ sender: Any) {
        var isGridLayout: Bool =  UserDefaults.standard.bool(forKey: "isGridLayout")
        isGridLayout = isGridLayout == true ? false : true
        UserDefaults.standard.set(isGridLayout, forKey: "isGridLayout")
        if isGridLayout == true {
            changeLayoutBtn.image = UIImage(systemName: "list.bullet")
        } else {
            changeLayoutBtn.image = UIImage(systemName: "square.grid.2x2")
        }
        presenter.didTapChangeLayoutBtn()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfSectionPage()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PageCollectionViewCell", for: indexPath)
                as? PageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.setupData(currentPage: indexPath.item,
                       popular: listPopularMovies,
                       topRated: listTopRatedMovies,
                       upcomming: listUpcommingMovies,
                       nowPlaying: listNowPlayingMovies)
        cell.setPresenter(data: presenter)
        cell.contentCollectionView.reloadData()
        cell.contentTableView.reloadData()
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: HomeViewViewProtocol {
    func displayAllMovies(popular: [Movie], topRated: [Movie], upcomming: [Movie], nowPlaying: [Movie]) {
        listPopularMovies = popular
        listTopRatedMovies = topRated
        listUpcommingMovies = upcomming
        listNowPlayingMovies = nowPlaying
        collectionViewContainer.reloadData()
    }

    func displayPopularMovies(_ listMovies: [Movie]) {
        listPopularMovies = listMovies
        collectionViewContainer.reloadData()
    }

    func displayTopRatedMovies(_ listMovies: [Movie]) {
        listTopRatedMovies = listMovies
        collectionViewContainer.reloadData()
    }

    func displayUpcommingMovies(_ listMovies: [Movie]) {
        listUpcommingMovies = listMovies
        collectionViewContainer.reloadData()

    }

    func displayNowPlayingMovies(_ listMovies: [Movie]) {
        listNowPlayingMovies = listMovies
        collectionViewContainer.reloadData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        categoryMenuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 5
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        categoryMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

// MARK: - PageCollectionViewCellDelegate
extension HomeViewController: PageCollectionViewCellDelegate {
    func didSelectMovie(movieSelected: Movie) {
        if let movieDetailVC = UIStoryboard(name: "MovieDetail", bundle: nil)
            .instantiateViewController(withIdentifier: "MovieDetailViewController")
            as? MovieDetailViewController {
            movieDetailVC.movieId = movieSelected.id
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }

    func scrollToPageCollectionViewCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionViewContainer.isPagingEnabled = false
        self.collectionViewContainer.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        categoryMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionViewContainer.isPagingEnabled = true
    }
}

// MARK: - Handle Scroll Tabbar
extension HomeViewController: CategoryMenuBarDelegate {
    func didSelectButtonMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionViewContainer.isPagingEnabled = false
        self.collectionViewContainer.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionViewContainer.isPagingEnabled = true
    }
}
