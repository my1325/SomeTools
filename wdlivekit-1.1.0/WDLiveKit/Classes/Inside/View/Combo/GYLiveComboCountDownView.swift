//
//  YHWComboView.swift
//  giftTest
//
//  Created by huawei on 2022/6/1.
//

import UIKit

class GYLiveComboCountDownView: UIView {
    let imageView:UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: UIImage(named: "fb_icon_combo", in: Bundle(for: GYLiveComboCountDownView.self), with: nil))
            return view
        } else {
            let view = UIImageView(image: UIImage(named: "fb_icon_combo"))
            return view
        }
    }()
    
    lazy var countDownLayer = CAShapeLayer()
    
    var countDownTimer:Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startCountDown() -> Void {
        addCountDownAnimation()
        addScaleAnimation()
    }
    
    func addCountDownAnimation() -> Void {
        layer.addSublayer(countDownLayer)
        
        let centerX = frame.width / 2.0
        let centerY = frame.height / 2.0
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: min(centerX, centerY), startAngle:-0.5 * CGFloat.pi, endAngle: -2.5 * CGFloat.pi, clockwise: false)
        countDownLayer.path = path.cgPath
        countDownLayer.strokeStart = 0.0
        countDownLayer.strokeEnd = 1.0
        countDownLayer.fillColor = UIColor.clear.cgColor
        countDownLayer.strokeColor = UIColor.white.cgColor
        countDownLayer.lineWidth = 3.0
        countDownLayer.lineCap = .round
        
        let animation = CABasicAnimation()
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 3.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        countDownLayer.add(animation, forKey: "strokeEnd")
        
        if let timer = countDownTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: animation.duration, repeats: false, block: { _ in
            if let comboView = self.superview as? GYLiveComboView {
                comboView.finishCountDown()
            }
        })
        
        guard countDownTimer != nil else {
            return
        }
        RunLoop.main.add(countDownTimer!, forMode: .common)
    }
    
    func addScaleAnimation() -> Void {
        let animation = CASpringAnimation()
        animation.duration = 2.5
        animation.fromValue = 0.83
        animation.toValue = 1.0
        animation.damping = 100.0
        animation.isRemovedOnCompletion = true
        
        layer.add(animation, forKey: "transform.scale")
    }
}

extension GYLiveComboCountDownView : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if UIApplication.shared.applicationState != .active {
            if let comboView = superview as? GYLiveComboView {
                comboView.finishCountDown()
            }
        }else if flag {
            if let comboView = superview as? GYLiveComboView {
                comboView.finishCountDown()
            }
        }
        
    }
}
