//
//  YHWComboAnimator.swift
//  giftTest
//
//  Created by huawei on 2022/5/31.
//

import UIKit

var xRan = -1

@objcMembers open class LJLiveComboAnimator: NSObject {
    public static let shared = LJLiveComboAnimator()
    public var comboCount = 0
    
    private var containerView:UIView = UIView()
    private var giftImage = UIImage()
    private var imageViewArray = Array<UIImageView>()
    
    private let defaultImageWidth = 40.0
    private var imageSize = CGSize(width: 40.0, height: 40.0)
    private var animatorSet:UIDynamicAnimator!
    private var animatorGravity:UIGravityBehavior!
    private var animatorCollision:UICollisionBehavior!
    private var animatorItem:UIDynamicItemBehavior!
    private var yPush:UIPushBehavior = UIPushBehavior(items: [], mode: .instantaneous)
    private var timer:Timer?
    private var endTimer:Timer?
    
    public var isAnimating:Bool {
        get {
            return animating
        }
    }
    
    public var isPlayingSelf:Bool {
        get {
            return playingSelf
        }
    }
    private var playingSelf = false
    private var animating = false
    
    override init() {
        super.init()
        
        containerView.isUserInteractionEnabled = false
        
        animatorSet = UIDynamicAnimator(referenceView: containerView)
        
        animatorGravity = UIGravityBehavior();
        animatorGravity.gravityDirection = CGVector(dx: 0.0, dy: 3.0)
        animatorGravity.magnitude = 0.7
        // 绑定动画
        animatorSet.addBehavior(animatorGravity)
        
        animatorCollision = UICollisionBehavior()
        animatorCollision.collisionMode = .items
        animatorSet.addBehavior(animatorCollision)
        
        animatorItem = UIDynamicItemBehavior()
        animatorItem.elasticity = 0.75
        animatorItem.friction = 0.1
        animatorItem.resistance = 0.0
        animatorSet.addBehavior(animatorItem)
        
        animatorSet.addBehavior(yPush)
    }
    
    public func startComboAnimation(image:UIImage? = nil,imageSize size:CGSize = CGSize(width: 40.0, height: 40.0),containerView view:UIView,count:Int = 5,isSelf:Bool = false) -> Void {
        view.addSubview(containerView)
        containerView.frame = view.bounds
        if let unpackImage = image {
            giftImage = unpackImage
        } else {
            if #available(iOS 13.0, *) {
                giftImage = UIImage(named: "dr_icon_combo_default_image", in: Bundle(for: LJLiveComboCountDownView.self), with: nil) ?? UIImage()
            } else {
                giftImage = UIImage(named: "dr_icon_combo_default_image") ?? UIImage()
            }
        }
        if size.height <= 0.0 || size.width <= 0.0 {
            imageSize = CGSize(width: 40.0, height: 40.0)
        } else {
            imageSize = size
        }
        
        comboCount = count
        
        animating = true
        playingSelf = isSelf
        begin()
        
        endTimer?.invalidate()
        
        endTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.stopComboAnimation()
        }
    }
    
    func begin() -> Void {
        guard animating else {
            return
        }
        
        timer?.invalidate()
        let distance = max(0.035, 0.7/Double(comboCount))
        timer = Timer.scheduledTimer(withTimeInterval: distance, repeats: false) { _ in
            self.createGiftAnimation()
            self.begin()
        }
        guard timer != nil else {
            return
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func createGiftAnimation() -> Void {
        for imageView in imageViewArray {
            if containerView.bounds.contains(imageView.center) == false {
                imageView.removeFromSuperview()
                self.animatorGravity.removeItem(imageView)
                self.animatorCollision.removeItem(imageView)
                self.animatorItem.removeItem(imageView)
                imageViewArray.removeAll(where: {$0 == imageView})
            }
        }
        
        let dx = Int(arc4random() % 5) - 2
        
        let containerWidth = containerView.frame.width
        let imageWidth = imageSize.width
        let giftView = UIImageView(frame: CGRect(x: 0, y: containerView.frame.height, width: imageSize.width, height: imageSize.height))
        giftView.image = giftImage
        containerView.addSubview(giftView)
        giftView.center = CGPoint(x: containerWidth / 2.0 + CGFloat(dx) * imageWidth, y: containerView.frame.height - imageWidth / 2.0)
        imageViewArray.append(giftView)
        
        let ranX = CGFloat(Int(arc4random() % 41) * xRan + 270) / 180.0 * 3.14
        
        yPush.active = true
        yPush.angle = ranX
        xRan *= -1
        
        let co = imageWidth / defaultImageWidth
        let mag = CGFloat(min(1.0 + Float(comboCount) / 3.0 * 0.0185, 1.5))
        yPush.magnitude = CGFloat(mag * co)
        animatorGravity.magnitude = 0.7 / co
        
        yPush.addItem(giftView)
        self.animatorGravity.addItem(giftView)
        self.animatorCollision.addItem(giftView)
        self.animatorItem.addItem(giftView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.yPush.removeItem(giftView)
        }
    }
    
    public func stopComboAnimation(immediately:Bool = false) -> Void {
        animating = false
        playingSelf = false
        DispatchQueue.main.asyncAfter(deadline: .now() + (immediately ? 0.0 : 5.0)) {
            if self.animating == false {
                self.clear()
            }
        }
    }
    
    func clear() -> Void {
        for imageView in imageViewArray {
            imageView.removeFromSuperview()
            self.animatorGravity.removeItem(imageView)
            self.animatorCollision.removeItem(imageView)
            self.animatorItem.removeItem(imageView)
            imageViewArray.removeAll(where: {$0 == imageView})
        }
    }
}
