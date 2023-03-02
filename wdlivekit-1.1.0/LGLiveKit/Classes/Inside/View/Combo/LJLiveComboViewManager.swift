//
//  YHWComboViewManager.swift
//  HWBaseKit
//
//  Created by huawei on 2022/6/16.
//

import UIKit

@objcMembers public class LJLiveComboViewManager: NSObject {
    public static let shared = LJLiveComboViewManager()
    var comboViewArray = Array<LJLiveComboView>()
    
    var currentView:LJLiveComboView? {
        willSet{
            currentView?.isHidden = true
            //            currentView?.removeFromSuperview()
        }
        
    }
    
    public func lj_clickedGift(giftId:Int,roomId:Int,frame:CGRect,containerView:UIView,isQuick:Bool = false,numberFont:UIFont? = nil) {
        var comboView:LJLiveComboView?
        if let view = comboViewArray.filter({$0.giftId == giftId && $0.roomId == roomId}).first {
            if view.isQuick == isQuick {
                comboView = view
            } else {
                let newView = LJLiveComboView(frame: frame,isQuick: isQuick,numberFont: numberFont)
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
            let view = LJLiveComboView(frame: frame,isQuick: isQuick,numberFont: numberFont)
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
    
    public func lj_removeCurrentViewFromSuperView() -> Void {
        currentView?.isHidden = true
        //        currentView?.removeFromSuperview()
    }
}

extension LJLiveComboViewManager : LJLiveComboViewDelegate {
    public func lj_comboViewDidEndCountDown(_ comboView: LJLiveComboView) {
        comboView.removeFromSuperview()
        comboViewArray.removeAll(where: {$0 == comboView})
    }
}
