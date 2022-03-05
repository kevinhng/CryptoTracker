//
//  SegmentedControl.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 05.03.22.
//

import UIKit

protocol SegmentedControlDelegate: NSObject {
    func didSelectSegment(_ segment: ChartDays)
}

@IBDesignable
class SegmentedControl: UIView {
    @IBInspectable var textColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectorColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    var buttonTitles: [String] = [] {
        didSet {
            updateView()
        }
    }
    
    private var buttons = [UIButton]()
    private var selector: UIView!
    
    weak var delegate: SegmentedControlDelegate?
    
    private func updateView() {
        buttons.removeAll()
        
        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        selector = UIView()
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        let selectorWidth = bounds.width / CGFloat(buttonTitles.count) - 20
        selector.frame = CGRect(x: 10, y: 0, width: selectorWidth, height: bounds.height)
        selector.backgroundColor = selectorColor
        selector.layer.cornerRadius = frame.height / 2
        addSubview(selector)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            
            if button == sender {
                button.setTitleColor(selectorTextColor, for: .normal)
                let selectorStartPosition = bounds.width / CGFloat(buttons.count) * CGFloat(index)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                    self.selector.frame.origin.x = selectorStartPosition + 10 })
                
                delegate?.didSelectSegment(ChartDays.allCases.first(where: {$0.rawValue == button.titleLabel?.text}) ?? .thirty)
            }
        }
    }
}
