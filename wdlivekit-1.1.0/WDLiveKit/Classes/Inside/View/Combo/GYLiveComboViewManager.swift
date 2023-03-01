//
//  YHWComboViewManager.swift
//  HWBaseKit
//
//  Created by huawei on 2022/6/16.
//

import UIKit

@objcMembers public class GYLiveComboViewManager: NSObject {
    public static let shared = GYLiveComboViewManager()
    var comboViewArray = Array<GYLiveComboView>()
    
    var currentView:GYLiveComboView? {
        willSet{
            currentView?.isHidden = true
            //            currentView?.removeFromSuperview()
        }
        
    }
    
    public func fb_clickedGift(giftId:Int,roomId:Int,frame:CGRect,containerView:UIView,isQuick:Bool = false,numberFont:UIFont? = nil) {
        var comboView:GYLiveComboView?
        if let view = comboViewArray.filter({$0.giftId == giftId && $0.roomId == roomId}).first {
            if view.isQuick == isQuick {
                comboView = view
            } else {
                let newView = GYLiveComboView(frame: frame,isQuick: isQuick,numberFont: numberFont)
                newView.giftId = giftId
                newView.roomId = roomId
                newView.comboCount = view.comboCount
                newView.delegate = self
                newView.isUserInteractionEnabled = false
                comboViewArray.append(newView)
                comboView = newView
                comboViewArray.removeAll(where: {$0 == view})
            }
            
        } else {
            let view = GYLiveComboView(frame: frame,isQuick: isQuick,numberFont: numberFont)
            view.giftId = giftId
            view.roomId = roomId
            view.delegate = self
            view.isUserInteractionEnabled = false
            comboViewArray.append(view)
            comboView = view
        }
        
        currentView = comboView
        
        containerView.addSubview(comboView!)
        comboView?.isHidden = false
        comboView?.rise()
    }
    
    public func fb_removeCurrentViewFromSuperView() -> Void {
        currentView?.isHidden = true
        //        currentView?.removeFromSuperview()
    }
}

extension GYLiveComboViewManager : GYLiveComboViewDelegate {
    public func fb_comboViewDidEndCountDown(_ comboView: GYLiveComboView) {
        comboView.removeFromSuperview()
        comboViewArray.removeAll(where: {$0 == comboView})
    }
}
