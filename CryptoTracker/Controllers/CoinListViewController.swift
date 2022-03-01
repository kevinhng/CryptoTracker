//
//  CoinListViewController.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 01.03.22.
//

import UIKit

class CoinListViewController: UITableViewController {
    
    private var coins: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        getCoins()
    }
    
    private func getCoins() {
        CoinDataService.shared.getCoins { [weak self] result in
            switch result {
            case .success(let coins):
                self?.coins = coins
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Crypto Tracker"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Table view data source
extension CoinListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
