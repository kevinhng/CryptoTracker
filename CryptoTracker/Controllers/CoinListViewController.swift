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
        configureTableView()
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
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Crypto Tracker"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Table view data source
extension CoinListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        cell.textLabel?.text = coins[indexPath.row].name
        return cell
    }
}
