//
//  YHWRippleView.swift
//  giftTest
//
//  Created by huawei on 2022/6/9.
//

import UIKit

class LJLiveComboRippleView: UIView {
    
    func addRipple() -> Void {
        let pulseLayer = CAShapeLayer()
        pulseLayer.frame = bounds
        pulseLayer.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 83.0/255.0, alpha: 0.7).cgColor
        pulseLayer.opacity = 0.0
        pulseLayer.cornerRadius = layer.bounds.size.height / 2.0
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.isRemovedOnCompletion = true
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.6
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [opacityAnimation,scaleAnimation]
        groupAnimation.duration = 1.0
        groupAnimation.autoreverses = false
        groupAnimation.repeatCount = 1
        
        pulseLayer.add(groupAnimation, forKey: "groupAnimation")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = bounds
        replicatorLayer.instanceCount = 1
        
        layer.addSublayer(replicatorLayer)
        
        replicatorLayer.addSublayer(pulseLayer)
        
    }
}
