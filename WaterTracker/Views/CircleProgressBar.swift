//
//  CircleProgressBar.swift
//  WaterTracker
//
//  Created by 김우현 on 2023/06/01.
//

import UIKit


final class CircleProgressBar: UIView {

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(Double.pi / 2)
    private var endPoint = CGFloat(5 * Double.pi / 2)
    private var progressColor = UIColor(red: CGFloat(50)/255.0, green: CGFloat(190)/255.0, blue: CGFloat(247)/255.0, alpha: 1.0).cgColor
    
    var plusWater = 0.0
    
    let user = UserDefaults.standard
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createCircularPath() {
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 130, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 17.0
        //circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 17.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor
        
        layer.addSublayer(progressLayer)
    }
    
    
    func progressAnimation(value: Double) {
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.fromValue = user.double(forKey: "plusWater")
        
        plusWater = user.double(forKey: "plusWater")
        
        plusWater += value
        
        user.set(plusWater, forKey: "plusWater")
        
        circularProgressAnimation.toValue = user.double(forKey: "plusWater")
        circularProgressAnimation.duration = 0.8

        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: nil)
    }
    
    func saveProgressAnimation() {
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.fromValue = 0.0
        
        circularProgressAnimation.toValue = user.double(forKey: "plusWater")
        circularProgressAnimation.duration = 0.5

        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: nil)

    }
    
}
