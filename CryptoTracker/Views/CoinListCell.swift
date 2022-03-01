//
//  CoinListCell.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 01.03.22.
//

import UIKit

class CoinListCell: UITableViewCell {
    
    static let cellIdentifier = "CoinListCell"
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinPriceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with coin: Coin) {
        addSubviews()
        
        coinNameLabel.text = coin.name
        coinSymbolLabel.text = coin.symbol
        coinPriceLabel.text = "\(coin.currentPrice ?? 0)"
        coinPriceChangeLabel.text = "\(coin.priceChangePercentage24H ?? 0)%"
    }
    
    private func addSubviews() {
        addSubview(coinImageView)
        
        coinImageView.image = UIImage(systemName: "circle.fill")
        
        addSubview(coinNameLabel)
        addSubview(coinSymbolLabel)
        addSubview(coinPriceLabel)
        addSubview(coinPriceChangeLabel)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let verticalSpacing: CGFloat = 2
        
        NSLayoutConstraint.activate([
            coinImageView.widthAnchor.constraint(equalToConstant: 44),
            coinImageView.heightAnchor.constraint(equalToConstant: 44),
            coinImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            coinNameLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 5),
            coinSymbolLabel.leadingAnchor.constraint(equalTo: coinNameLabel.leadingAnchor),
            NSLayoutConstraint(item: coinSymbolLabel, attribute: .top, relatedBy: .equal, toItem: coinNameLabel, attribute: .bottom, multiplier: 1, constant: verticalSpacing),
            
            coinPriceLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            coinPriceChangeLabel.trailingAnchor.constraint(equalTo: coinPriceLabel.trailingAnchor),
            NSLayoutConstraint(item: coinPriceChangeLabel, attribute: .top, relatedBy: .equal, toItem: coinPriceLabel, attribute: .bottom, multiplier: 1, constant: verticalSpacing),
        ])
    }
}
