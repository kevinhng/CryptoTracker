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
        return layer
    }()
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        graphLayer.path = drawGraph()
        graphLayer.strokeColor = UIColor.white.cgColor
        graphLayer.lineWidth = 2
        layer.addSublayer(graphLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawGraph() -> CGPath {
        let points = viewModel.data.normalized
        let width = frame.width
        let height = frame.height
        
        let xPoint = { (index: Int) -> CGFloat in
            let spacing = width / CGFloat(points.count - 1)
            return CGFloat(index) * spacing
        }
        
        let yPoint = { (point: Double) -> CGFloat in
            let y = CGFloat(point) * height
            return height - y
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xPoint(0), y: yPoint(points[0])))
        
        for i in 1..<points.count {
            let nextPoint = CGPoint(x: xPoint(i), y: yPoint(points[i]))
            path.addLine(to: nextPoint)
        }
        
        return path.cgPath
    }
    
    
    
//        override func draw(_ rect: CGRect) {
//            let points = viewModel.data.normalized
//
//            let width = rect.width
//            let height = rect.height
//            let maxValue = viewModel.data.max() ?? 0
//
//            let columnXPoint = { (column: Int) -> CGFloat in
//                let spacing = width / CGFloat(self.viewModel.data.count - 1)
//                return CGFloat(column) * spacing
//            }
//
//            let columnYPoint = { (graphPoint: Double) -> CGFloat in
//                let yPoint = CGFloat(graphPoint) * height
//                return height - yPoint
//            }
//            UIColor.white.setFill()
//            UIColor.white.setStroke()
//
//            let graphPath = UIBezierPath()
//
//            graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(points[0])))
//
//            for i in 1..<viewModel.data.count {
//                let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(points[i]))
//                print(nextPoint)
//                graphPath.addLine(to: nextPoint)
//            }
//            graphPath.lineWidth = 2
//            graphPath.stroke()
//
//
//        }
}
