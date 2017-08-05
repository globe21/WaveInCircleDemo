//
//  Wave1.swift
//  RDWaveDemo
//
//  Created by 鞠汶成 on 05/08/2017.
//  Copyright © 2017 鞠汶成. All rights reserved.
//

import UIKit

@IBDesignable
class WaveInCircleView: UIView {
    // MARK: public property
    var offsetDegree: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var hightlightColor: UIColor? {
        didSet {
            label2.backgroundColor = hightlightColor
            label1.textColor = hightlightColor
        }
    }
    
    var normalColor: UIColor? {
        didSet {
            label1.backgroundColor = normalColor
            label2.textColor = normalColor
        }
    }
    
    var yScale: CGFloat = 20 // 波峰到波谷高度40
    
    var progress: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: String? {
        didSet {
            label1.text = text
            label2.text = text
        }
    }
    
    func animate() {
        timer = Timer.scheduledTimer(timeInterval: 1/50, target: self, selector: #selector(changeOffsetDegree), userInfo: nil, repeats: true)
    }
    
    func stopAnimate() {
        timer?.invalidate()
    }
    
    // MARK: initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: private
    private var label1: UILabel = {
        let l1 = UILabel(frame: .zero)
        l1.font = UIFont.systemFont(ofSize: 100)
        l1.textColor = UIColor.blue
        l1.backgroundColor = .white
        l1.textAlignment = .center
        l1.text = "RD"
        l1.clipsToBounds = true
        l1.adjustsFontSizeToFitWidth = true
        return l1
    }()
    
    private var label2: UILabel = {
        let l2 = UILabel(frame: .zero)
        l2.text = "RD"
        l2.textColor = .white
        l2.backgroundColor = .blue
        l2.font = UIFont.systemFont(ofSize: 100)
        l2.textAlignment = .center
        l2.clipsToBounds = true
        l2.adjustsFontSizeToFitWidth = true
        return l2
    }()
    
    private func commonInit() {
        clipsToBounds = true
        addSubview(label2)
        addSubview(label1)
        
        addLayoutConstraint(with: "H:|[v0]|", views: label2)
        addLayoutConstraint(with: "V:|[v0]|", views: label2)
        addLayoutConstraint(with: "H:|[v0]|", views: label1)
        addLayoutConstraint(with: "V:|[v0]|", views: label1)
    }
    
    private var viewMaskLayer: CAShapeLayer?
    
    // Fixed: 不设置 strokeColor 会使上半圆有下半圆填充颜色的边框，设置后消失，但是设置颜色并没有显示出来
    private var label1MaskLayer: CAShapeLayer = {
        let sl = CAShapeLayer()
        sl.strokeColor = UIColor.blue.cgColor
        sl.lineWidth = 0
        return sl
    }()
    
    private var circlePath: UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        if viewMaskLayer == nil {
            viewMaskLayer = CAShapeLayer()
            let path = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.width/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            viewMaskLayer?.path = path.cgPath
            layer.mask = viewMaskLayer
        }
        
        label1MaskLayer.path = path.cgPath
        self.label1.layer.mask = label1MaskLayer
    }
    
    // compute property
    private var path: UIBezierPath {
        get {
            let height = bounds.height
            let width = bounds.width
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: 0, y: height/2))
            for step in stride(from: 0, to: 2 * CGFloat.pi, by: CGFloat.pi / 180) {
                path.addLine(to: point(with: step, offsetDegree: self.offsetDegree))
            }
            
            path.addLine(to: CGPoint(x: width, y: height/2))
            if circlePath == nil {
                let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
                let radius: CGFloat = max(bounds.width, bounds.height)
                let startAngle: CGFloat = 0
                let endAngle: CGFloat = CGFloat.pi
                circlePath = UIBezierPath(arcCenter: center,
                                          radius: radius/2,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: false)
            }
            path.append(circlePath!)
            
            return path
        }
    }
    
    private func point(with degree: CGFloat, offsetDegree: CGFloat) -> CGPoint {
        let moveToX = bounds.width * 0.5 / CGFloat.pi * degree
        // cause
        let moveToY = bounds.height * (1 - progress) - yScale * CGFloat(sin(degree - offsetDegree))
        
        return CGPoint(x: moveToX, y: moveToY)
    }
    
    private var timer: Timer?
    
    @objc private func changeOffsetDegree() {
        // 1秒变换180度
        self.offsetDegree = self.offsetDegree + CGFloat.pi * 0.015
    }
    
    deinit {
        print("deinit")
    }
}
