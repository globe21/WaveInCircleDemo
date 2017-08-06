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
    // MARK: Public property and Method
    var hightlightColor: UIColor? {
        didSet {
            backLabel.backgroundColor = hightlightColor
            frontLabel.textColor = hightlightColor
        }
    }
    
    var normalColor: UIColor? {
        didSet {
            frontLabel.backgroundColor = normalColor
            backLabel.textColor = normalColor
        }
    }
    
    var amplitudeValue: CGFloat = 20 // 波幅
    
    var fillingProgress: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: String? {
        didSet {
            frontLabel.text = text
            backLabel.text = text
        }
    }
    
    func animate() {
        waveTimer = Timer.scheduledTimer(timeInterval: 1/50, target: self, selector: #selector(changeOffsetDegree), userInfo: nil, repeats: true)
    }
    
    func stopAnimate() {
        waveTimer?.invalidate()
        waveTimer = nil
    }
    
    // MARK: Initialize and draw
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        addSubview(backLabel)
        addSubview(frontLabel)
        
        addLayoutConstraint(with: "H:|[v0]|", views: backLabel)
        addLayoutConstraint(with: "V:|[v0]|", views: backLabel)
        addLayoutConstraint(with: "H:|[v0]|", views: frontLabel)
        addLayoutConstraint(with: "V:|[v0]|", views: frontLabel)
    }
    
    override func draw(_ rect: CGRect) {
        applyViewMask()
        applyFrontLabelMask()
    }
    
    // MARK: Private
    private var waveTimer: Timer?
    private lazy var topHalfArcPath: UIBezierPath = {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let radius: CGFloat = max(self.bounds.width, self.bounds.height)
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = CGFloat.pi
        let path = UIBezierPath(arcCenter: center,
                                  radius: radius/2,
                                  startAngle: startAngle,
                                  endAngle: endAngle,
                                  clockwise: false)
        return path
        
    }()
    private var viewCircleMaskLayer: CAShapeLayer?
    
    private var offsetDegree: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var frontLabel: UILabel = {
        let label = self.label(withText: "DO", textColor: .blue, backgroundColor: .white)
        return label
    }()
    
    private lazy var backLabel: UILabel = {
        let label = self.label(withText: "DO", textColor: .white, backgroundColor: .blue)
        return label
    }()
    
    private func label(withText: String, textColor: UIColor, backgroundColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = withText
        label.clipsToBounds = true
        label.textColor = textColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = backgroundColor
        label.font = UIFont.systemFont(ofSize: 100)
        return label
    }
    
    // Fixed: 不设置 strokeColor 会使上半圆有下半圆填充颜色的边框，设置后消失，但是设置颜色并没有显示出来
    private var frontLabelMaskLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 0
        return shapeLayer
    }()
    
    // compute property
    private var frontLabelMaskPath: UIBezierPath {
        get {
            let height = bounds.height
            let width = bounds.width
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: 0, y: height/2))
            for step in stride(from: 0, to: 2 * CGFloat.pi, by: CGFloat.pi / 180) {
                path.addLine(to: point(with: step, offsetDegree: self.offsetDegree))
            }
            
            path.addLine(to: CGPoint(x: width, y: height/2))
            path.append(topHalfArcPath)
            
            return path
        }
    }
    
    // MARK: Helpers
    private func setFrontBackLabelFontColorAndBackgroundColor(color: UIColor?) {
        backLabel.backgroundColor = color
        frontLabel.textColor = color
    }
    
    private func applyViewMask() {
        if viewCircleMaskLayer == nil {
            viewCircleMaskLayer = CAShapeLayer()
            let path = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.width/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            viewCircleMaskLayer?.path = path.cgPath
            layer.mask = viewCircleMaskLayer
        }
    }
    
    private func applyFrontLabelMask() {
        frontLabelMaskLayer.path = frontLabelMaskPath.cgPath
        frontLabel.layer.mask = frontLabelMaskLayer
    }
    
    private func point(with degree: CGFloat, offsetDegree: CGFloat) -> CGPoint {
        let xPosition = bounds.width * 0.5 / CGFloat.pi * degree
        // cause
        let yPosition = bounds.height * (1 - fillingProgress) - amplitudeValue * CGFloat(sin(degree - offsetDegree))
        
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    @objc private func changeOffsetDegree() {
        // 1秒变换180度
        self.offsetDegree = self.offsetDegree + CGFloat.pi * 0.015
    }
    
    deinit {
        print("deinit")
    }
}
