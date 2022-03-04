//
//  CoinDetailTitleView.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import UIKit

class CoinDetailTitleView: UIStackView {
    
    private var coin: Coin?
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
        
    func configure(with coin: Coin) {
        self.coin = coin
        getImage()
        titleLabel.text = coin.name
        configureStackView()
    }
    
    private func configureStackView() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 5
        
        addArrangedSubview(coinImageView)
        addArrangedSubview(titleLabel)
    }
    
    private func getImage() {
        guard let coin = coin else { return }
        
        CoinImageService.shared.getImage(for: coin) { [weak self] completion in
            switch completion {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.coinImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
