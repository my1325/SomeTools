//
//  LJLiveRemoteView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRemoteView : UIView

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *maskButton;

@property (nonatomic, strong) UIImageView *backgroudImageView;
/// 提示文案
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, copy) LJLiveVoidBlock closeBlock, maskBlock;


/// 视频（自己）
@property (nonatomic, strong) UIView * __nullable videoView;
/// pk视频(对方)
@property (nonatomic, strong) UIView * __nullable pkVideoView;
/// 提示文案
@property (nonatomic, strong) NSString *promptText;

@end

NS_ASSUME_NONNULL_END
