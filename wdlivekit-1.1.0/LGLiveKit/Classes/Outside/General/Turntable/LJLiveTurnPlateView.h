//
//  CBTurnPlateView.h
//  CamBox
//
//  Created by Wyz on 2021/11/16.
//  Copyright © 2021 CamBox. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveTurnPlateView : UIView









/// 接收主播端的消息
/// 主播关闭或者打开转盘
/// 用户主动隐藏转盘
/// @param dic <#dic description#>
-(void)reciveTurnPlateInfoData:(NSDictionary*)dic;
-(void)updateRoomInfo:(LJLiveRoom*)roomModel;
-(void)showView;
-(void)hiddenView;
@property (nonatomic,copy) LJLiveVoidBlock hostCloseOpenTurnPlateBlock;
@property (nonatomic,copy) LJLiveTextBlock showResultBlock;
@property (nonatomic,copy) LJLiveVoidBlock hiddenBlock;
@property (nonatomic,assign) BOOL isShowing;
@end

NS_ASSUME_NONNULL_END
