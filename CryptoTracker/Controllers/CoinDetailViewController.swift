//
//  CoinDetailViewController.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import UIKit

class CoinDetailViewController: UIViewController {
    
    private var coin: Coin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }
    
    func configure(with coin: Coin) {
        self.coin = coin
    }
    
    private func configureNavigationBar() {
        if #available(iOS 14.0, *) {
            navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
}
