//
//  ActivityLoadingView.swift
//  SmartMovie
//
//  Created by Hoang Viet on 08/04/2023.
//

import UIKit

class ActivityLoadingView: UICollectionReusableView {

    @IBOutlet weak var activityLoading: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityLoading.startAnimating()
    }

}
