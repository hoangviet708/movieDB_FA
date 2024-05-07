//
//  BaseViewController.swift
//  SmartMovie
//
//  Created by Hoang Viet on 08/04/2023.
//

import UIKit

class BaseViewController: UIViewController {

    private var loadingView: UIActivityIndicatorView?
    private var blockView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showLoading() {
        loadingView = UIActivityIndicatorView(style: .large)
        blockView = UIView()
        loadingView?.color = .gray
        loadingView?.center = self.view.center
        guard let loadingView = loadingView,
              let blockView = blockView
            else {
            return
        }
        blockView.isUserInteractionEnabled = true
        blockView.backgroundColor = .clear
        view.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
        blockView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blockView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        blockView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blockView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blockView.addSubview(loadingView)
        loadingView.startAnimating()
   }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView?.stopAnimating()
            self?.blockView?.removeFromSuperview()
        }
    }

    func displayAlert(with title: String = AppConstant.appName, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let customActions = actions {
            customActions.forEach { action in
                alertController.addAction(action)
            }
        } else {
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okButton)
        }
        present(alertController, animated: true)
    }
}
