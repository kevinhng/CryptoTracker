//
//  CoinDetailViewController.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import UIKit

class CoinDetailViewController: UIViewController {
    
    private var coin: Coin?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var graphView: GraphView = {
        let graphView = GraphView(viewModel: GraphViewModel(coin: coin!, for: .one))
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.delegate = self
        return graphView
    }()
    
    private lazy var segmentedContol: SegmentedControl = {
        let segmentedControl = SegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.buttonTitles = ChartDays.allCases.map{ $0.rawValue }
        segmentedControl.textColor = .lightGray
        segmentedControl.selectorTextColor = .label
        segmentedControl.selectorColor = .secondarySystemFill
        segmentedControl.delegate = self
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        addSubviews()
        configureConstraints()
    }

    func configure(with coin: Coin) {
        self.coin = coin
        coinPriceLabel.text = coin.currentPrice?.asCurrency()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(coinPriceLabel)
        contentView.addSubview(graphView)
        contentView.addSubview(segmentedContol)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coinPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coinPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            graphView.topAnchor.constraint(equalTo: coinPriceLabel.bottomAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            graphView.heightAnchor.constraint(equalToConstant: 200),
            
            segmentedContol.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20),
            segmentedContol.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            segmentedContol.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            segmentedContol.heightAnchor.constraint(equalToConstant: 32)
            
            
        ])
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)), style: .plain, target: self, action: nil)
    }
}

// MARK: - SegmentedControl Delegate
extension CoinDetailViewController: SegmentedControlDelegate {
    func didSelectSegment(_ segment: ChartDays) {
        graphView.viewModel.getMarketChart(days: segment)
    }
}

// MARK: - GraphView Delegate
extension CoinDetailViewController: GraphViewDelegate {
    func didChange(_ price: Double) {
        coinPriceLabel.text = price.asCurrency()
    }
    
    func didEnd() {
        coinPriceLabel.text = coin?.currentPrice?.asCurrency()
    }
}
