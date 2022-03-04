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
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var coinPriceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var leftVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var rightVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    func configure(with coin: Coin) {
        addSubviews()
        
        getCoinImage(for: coin)
        coinNameLabel.text = coin.name
        coinSymbolLabel.text = coin.symbol.uppercased()
        coinPriceLabel.text = coin.currentPrice?.asCurrency()
        coinPriceChangeLabel.text = coin.priceChangePercentage24H?.asPercentString()
        coinPriceChangeLabel.textColor = coin.priceChangePercentage24H ?? 0 > 0 ? .systemGreen : .systemRed
    }
    
    private func getCoinImage(for coin: Coin) {
        CoinImageService.shared.getImage(for: coin) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let image):
                DispatchQueue.main.async {
                    self?.coinImageView.image = image
                }
            }
        }
    }
    
    private func addSubviews() {
        addSubview(coinImageView)
        
        arrangeStackViews()
        addSubview(hStackView)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            coinImageView.widthAnchor.constraint(equalToConstant: 36),
            coinImageView.heightAnchor.constraint(equalToConstant: 36),
            coinImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 10),
            hStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func arrangeStackViews() {
        leftVStackView.addArrangedSubview(coinNameLabel)
        leftVStackView.addArrangedSubview(coinSymbolLabel)
        
        rightVStackView.addArrangedSubview(coinPriceLabel)
        rightVStackView.addArrangedSubview(coinPriceChangeLabel)
        
        hStackView.addArrangedSubview(leftVStackView)
        hStackView.addArrangedSubview(rightVStackView)
    }
}
