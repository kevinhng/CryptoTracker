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
        
        let graphView = GraphView(viewModel: GraphViewModel(coin: coin!, for: .thirty))
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
    
    func configure(with coin: Coin) {
        self.coin = coin
    }
    
    private func configureNavigationBar() {
        if #available(iOS 14.0, *) {
            navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        }
        
        navigationController?.navigationBar.tintColor = .label
        
        guard let coin = coin else { return }
        
        let titleView = CoinDetailTitleView()
        titleView.configure(with: coin)
        navigationItem.titleView = titleView
        
        navigationItem.largeTitleDisplayMode = .never
    }
}
