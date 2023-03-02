//
//  LJLiveRemoteView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRemoteView : UIView







/// 提示文案
/// 视频（自己）
/// pk视频(对方)
/// 提示文案
@property (nonatomic, strong) UIView * __nullable pkVideoView;
@property (nonatomic, strong) NSString *promptText;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, copy) LJLiveVoidBlock closeBlock, maskBlock;
@property (nonatomic, strong) UIButton *maskButton;
@property (nonatomic, strong) UIImageView *backgroudImageView;
@property (nonatomic, strong) UIView * __nullable videoView;
@property (nonatomic, strong) UIButton *closeButton;
@end

NS_ASSUME_NONNULL_END
