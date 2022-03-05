//
//  GraphView.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import UIKit

class GraphView: UIView {
    
    var viewModel: GraphViewModel
    
    private lazy var graphLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = .none
        layer.strokeColor = UIColor.label.cgColor
        layer.lineWidth = 1.5
        layer.lineJoin = .round
        return layer
    }()
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        viewModel.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphLayer.path = drawGraph()
        layer.addSublayer(graphLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawGraph() -> CGPath {
        let path = UIBezierPath()
        let width = frame.width
        let height = frame.height
        
        guard let chart = viewModel.chart else {
            path.move(to: CGPoint(x: 0, y: height / 2))
            path.addLine(to: CGPoint(x: width, y: height / 2))
            return path.cgPath
        }
        
        let points = chart.dataPoints.normalized

        
        let xPoint = { (index: Int) -> CGFloat in
            let spacing = width / CGFloat(points.count - 1)
            return CGFloat(index) * spacing
        }
        
        let yPoint = { (point: Double) -> CGFloat in
            let y = CGFloat(point) * height
            return height - y
        }
        
        path.move(to: CGPoint(x: xPoint(0), y: yPoint(points[0])))
        
        for i in 1..<points.count {
            let nextPoint = CGPoint(x: xPoint(i), y: yPoint(points[i]))
            path.addLine(to: nextPoint)
        }
        
        return path.cgPath
    }
}

extension GraphView: GraphViewModelDelegate {
    func didLoad() {
        DispatchQueue.main.async {
            self.graphLayer.path = self.drawGraph()
        }
    }
}
