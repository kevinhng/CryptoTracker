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
    
    private lazy var plot: UIView = {
        let plot = UIImageView()
        plot.translatesAutoresizingMaskIntoConstraints = false
        plot.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let outerCircleDiameter: CGFloat = 48
        let innerCircleDiameter: CGFloat = 8
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: outerCircleDiameter, height: outerCircleDiameter))
        let img = renderer.image { ctx in
            
            ctx.cgContext.setFillColor(UIColor.systemGray6.cgColor)
            ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: outerCircleDiameter, height: outerCircleDiameter))
            ctx.cgContext.drawPath(using: .fill)
            
            ctx.cgContext.setFillColor(UIColor.label.cgColor)
            ctx.cgContext.addEllipse(in: CGRect(x: outerCircleDiameter / 2 - innerCircleDiameter / 2, y: outerCircleDiameter / 2 - innerCircleDiameter / 2, width: innerCircleDiameter, height: innerCircleDiameter))
            ctx.cgContext.drawPath(using: .fill)
        }
        plot.image = img
        
        return plot
    }()
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        viewModel.delegate = self
        
        configureGestures()
        
        addSubview(plot)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphLayer.path = drawGraph()
        layer.addSublayer(graphLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            HapticsManager.began.playFeedback()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: []) {
                self.plot.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
       
        // pan
        
        let width = frame.width
        let height = frame.height
        guard let chart = viewModel.chart else {
            return
        }
        
        let yPoint = { (point: Double) -> CGFloat in
            let y = CGFloat(point) * height
            return height - y
        }
        
        let points = chart.dataPoints.normalized
        
        let locationX = recognizer.location(in: self).x
        let spacing = width / CGFloat(points.count - 1)
        
        let index = Int(round(locationX / spacing))
        
        if (0...points.count - 1).contains(index) {
            plot.frame.origin = CGPoint(x: spacing * CGFloat(index) - 24 , y: yPoint(points[index]) - 24)
        }
        
        if recognizer.state == .ended {
            self.plot.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
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
    
    private func configureGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0
        addGestureRecognizer(longPress)
    }
}

extension GraphView: GraphViewModelDelegate {
    func didLoad() {
        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 0.4
            animation.byValue = self.drawGraph
            
            self.graphLayer.add(animation, forKey: animation.keyPath)
            self.graphLayer.path = self.drawGraph()
        }
    }
}
