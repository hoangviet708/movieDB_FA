//
//  CastListTableViewCell.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import UIKit

final class CastListTableViewCell: UITableViewCell {

    @IBOutlet weak var contentCollectionView: UICollectionView!

    private var castMovie: [Cast] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(data: [Cast]) {
        self.castMovie = data
        contentCollectionView.reloadData()
    }

    func setupCollectionView() {
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        contentCollectionView.collectionViewLayout = layout
        contentCollectionView.isPagingEnabled = true
        contentCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil),
                                       forCellWithReuseIdentifier: "CastCollectionViewCell")
    }
}

extension CastListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castMovie.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell",
                                                            for: indexPath) as? CastCollectionViewCell else {
            return CastCollectionViewCell()
        }
        let castItem: Cast = castMovie[indexPath.item]
        cell.setData(data: castItem)
        return cell
    }
}

extension CastListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 16 * 2
         let height = collectionView.bounds.height - 8
        return CGSize(width: width / 3, height: height / 2)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}
