//
//  YHWComboView.swift
//  giftTest
//
//  Created by huawei on 2022/6/9.
//

import UIKit
import SnapKit

public protocol LJLiveComboViewDelegate {
    func lj_comboViewDidEndCountDown(_ comboView:LJLiveComboView)
}

@objcMembers public class LJLiveComboView: UIView {
    public var roomId:Int = 0
    public var giftId:Int = 0
    
    public var delegate:LJLiveComboViewDelegate?
    public var comboCount = 0 {
        didSet{
            goodView.isHidden = comboCount < 10
            self.countLabel.text = "\(self.comboCount)"
            self.countDownView.startCountDown()
            self.rippleView.addRipple()
            
            if isQuick {
                if self.comboCount < 100 {
                    self.countLabel.snp.updateConstraints { make in
                        make.width.equalTo(25.0)
                    }
                }else if self.comboCount < 1000 {
                    self.countLabel.snp.updateConstraints { make in
                        make.width.equalTo(32.0)
                    }
                }else {
                    self.countLabel.snp.updateConstraints { make in
                        make.width.equalTo(39.0)
                    }
                }
            } else {
                let offsetHeight = min((self.comboCount - 1) * 7, 62)
                let height = 44.5 + Double(offsetHeight)
                self.countBarView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
                
                if self.comboCount < 100 {
                    self.countLabel.snp.updateConstraints { make in
                        make.width.equalTo(30.0)
                    }
                }else if self.comboCount < 1000 {
                    self.countLabel.snp.updateConstraints { make in
                        make.width.equalTo(41.0)
                    }
                }else {
                    self.countLabel.snp.updateConstraints { make in
                        make.width.equalTo(51.0)
                    }
                }
            }
        }
    }
    
    let rippleView = LJLiveComboRippleView()
    let countDownView = LJLiveComboCountDownView()
    var isQuick = false
    
    let countBarView:UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: UIImage(named: "lj_bg_count_bar", in: Bundle(for: LJLiveComboCountDownView.self), with: nil))
            return view
        } else {
            let view = UIImageView(image: UIImage(named: "lj_bg_count_bar"))
            return view
        }
    }()
    
    let goodView:UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: UIImage(named: "lj_icon_combo_good", in: Bundle(for: LJLiveComboCountDownView.self), with: nil))
            view.isHidden = true
            return view
        } else {
            let view = UIImageView(image: UIImage(named: "lj_icon_combo_good"))
            view.isHidden = true
            return view
        }
    }()
    
    lazy var countLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.text = "1"
        
        if self.isQuick {
            label.backgroundColor = .white
            label.layer.cornerRadius = 7.0
            label.textColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            label.font = .systemFont(ofSize: 10.0, weight: .black)
        } else {
            label.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 127.0/255.0, alpha: 1.0)
            label.layer.cornerRadius = 15.0
            label.textColor = .white
            label.font = .systemFont(ofSize: 16.0, weight: .black)
        }
        return label
    }()
    
    public init(frame: CGRect,isQuick quick:Bool,numberFont font:UIFont? = nil) {
        super.init(frame: frame)
        isQuick = quick
        if font != nil {
            countLabel.font = font!
        }
        initSubViews()
        layoutIfNeeded()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubViews()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
        layoutIfNeeded()
    }
    
    func initSubViews() -> Void {
        backgroundColor = .clear
        addSubview(rippleView)
        addSubview(countDownView)
        addSubview(countLabel)
        addSubview(goodView)
        
        if isQuick {//快速送礼
            
            rippleView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 51, height: 51))
                make.center.equalToSuperview()
            }
            
            countLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(18.5)
                make.top.equalTo(self.rippleView.snp.top).offset(2.0)
                make.height.equalTo(14.0)
                make.width.equalTo(25.0)
            }
            
            goodView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 49, height: 27))
                make.bottom.equalTo(self.countDownView.snp.top).offset(-3)
                make.centerX.equalTo(self.countDownView)
            }
            
        } else {//礼物列表送礼
            addSubview(countBarView)
            sendSubviewToBack(countBarView)
            
            rippleView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 72, height: 72))
                make.bottom.equalToSuperview().offset(-35.0)
                make.centerX.equalToSuperview()
            }
            
            countBarView.snp.makeConstraints { make in
                make.bottom.equalTo(self.rippleView.snp.centerY)
                make.width.equalTo(20.0)
                make.centerX.equalToSuperview()
                make.height.equalTo(44.5)
            }
            
            countLabel.snp.makeConstraints { make in
                make.centerX.equalTo(self.countBarView)
                make.bottom.equalTo(self.countBarView.snp.top).offset(5.5)
                make.height.equalTo(30.0)
                make.width.equalTo(30.0)
            }
            
            goodView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 49, height: 27))
                make.top.equalTo(self.countDownView).offset(-1)
                make.right.equalTo(self.countDownView).offset(19)
            }
        }
        
        countDownView.snp.makeConstraints { make in
            make.center.size.equalTo(self.rippleView)
        }
        
    }
    
    public func rise() -> Void {
        comboCount += 1
    }
    
    func finishCountDown() -> Void {
        delegate?.lj_comboViewDidEndCountDown(self)
    }
}
