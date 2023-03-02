//
//  CBTurnPlateView.m
//  CamBox
//
//  Created by Wyz on 2021/11/16.
//  Copyright © 2021 CamBox. All rights reserved.
//

#import "LJLiveTurnPlateView.h"
#import "LJLiveTurntableView.h"
#import "LJLiveAutoScrollLabel.h"

@interface LJLiveTurnPlateView() <CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet LJLiveAutoScrollLabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISwitch *turnPlateSwitch;
@property (weak, nonatomic) IBOutlet UIButton *turnEditBtn;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property(nonatomic,strong) LJLiveTurntableView *circleView;

/// 主播端随机选中的序号
@property (nonatomic,assign) NSInteger selectedIndex;

/// 转盘是否正在转
@property (nonatomic,assign) BOOL isAnimation;

@property(nonatomic,strong) NSMutableArray *luckyItemArray;

@property (strong,nonatomic) LJLiveTurntableViewModel * curItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewWidthConstraint;
@property(nonatomic,strong) CABasicAnimation *rotationAnimation;
@end

@implementation LJLiveTurnPlateView




















/// 接收到主播端的转盘更新消息通知
/// 点击转盘
/// @param dic <#dic description#>
/// 点击出了转盘外的区域事件处理
/// @param sender <#sender description#>
- (LJLiveTurntableViewModel *)getItemByIndex:(NSInteger)index
{
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF.index == %d",index];
    NSArray * result = [self.luckyItemArray filteredArrayUsingPredicate:pre];
    LJLiveTurntableViewModel * item = result.firstObject;
    return item;
}
-(LJLiveTurntableView*)circleView {
    
    if (_circleView == nil) {
        _circleView = [[LJLiveTurntableView alloc] init];
        //        _circleView.bg = self.bgImage;
        NSDictionary * attributes = @{
            NSForegroundColorAttributeName:UIColor.whiteColor,
            NSFontAttributeName:[UIFont boldSystemFontOfSize:10]
        };
        CGFloat scale = [UIScreen mainScreen].scale;
        if (scale == 2) {
            _circleView.circleWidth = 27.f;
        }else{
            _circleView.circleWidth = 31.f;
        }
        _circleView.imageSize = CGSizeMake(35, 35);
        
        _circleView.attributes = attributes;
        _circleView.panBgColors = [self getColorsWithItems:self.luckyItemArray];
        kLJWeakSelf;
        [_circleView setLunckyAnimationDidStopBlock:^(BOOL flag, LJLiveTurntableViewModel *item) {
            weakSelf.isAnimation = NO;
            //假如父级view已经被销毁了则不用显示结果
            if(weakSelf.superview != nil) {
                if (kLJLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn && kLJLiveHelper.data.current.turntableFlag == 1) {
                    weakSelf.showResultBlock(item.remark);
                }
            }
        }];
        _circleView.luckyItemArray = self.luckyItemArray;
    }
    
    return _circleView;
}
- (IBAction)bgClickAction:(id)sender {
    
}
-(IBAction)selfTap:(id)sender {
    self.hiddenBlock();
    self.isShowing = NO;
    
//    [self.circleView.layer removeAllAnimations]; 
    
}
-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.hidden = YES;
    
    self.isAnimation = NO;
    
    [self initItemDataArray];
    
    self.mainViewWidthConstraint.constant = kScreenWidth-30*2;
    self.mainViewHeightConstraint.constant = kScreenWidth-30*2;
    
    //这里裁剪主要是为了防止误点到了四角空白
    self.mainView.layer.cornerRadius = (kScreenWidth-30*2)/2;
    self.mainView.layer.masksToBounds = YES;
    
    [self.mainView addSubview:self.circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(-10);
        make.left.equalTo(self.mainView).offset(-10);
        make.bottom.equalTo(self.mainView).offset(10);
        make.right.equalTo(self.mainView).offset(10);
    }];
    
    [self.circleView.layer addAnimation:self.rotationAnimation forKey:@"autoRotationAnimation"];
    
    
    [self.mainView bringSubviewToFront:self.startBtn];
    
}
-(NSArray*)getColorsWithItems:(NSArray*)items {
    //偶数
    if (items.count%2 == 0) {
        return @[kLJColorFromRGBA(0xffffff,1.0),kLJColorFromRGBA(0xffffff, 0.9)];
    }else{
        if (items.count == 3) {
            return @[kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8)];
        }else if (items.count == 5) {
            return @[kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9)];
        }else if (items.count == 7) {
            return @[kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.8)];
        }else if (items.count == 9){
            return @[kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8)];
        }else if(items.count == 11) {
            return @[kLJColorFromRGBA(0xffffff,1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9),kLJColorFromRGBA(0xffffff, 0.8),kLJColorFromRGBA(0xffffff, 1.0),kLJColorFromRGBA(0xffffff, 0.9)];
            
        }else{
            return nil;
        }
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}
-(void)updateRoomInfo:(LJLiveRoom*)roomModel {
    
//    kLJLiveHelper.live = roomModel;
    
    [self.circleView.layer removeAllSublayers];
    
    [self initItemDataArray];
    
    //更新转盘信息
    self.circleView.panBgColors = [self getColorsWithItems:self.luckyItemArray];
    
    self.circleView.luckyItemArray = self.luckyItemArray;
}
-(CABasicAnimation *)rotationAnimation {
    
    if(_rotationAnimation == nil) {
        CABasicAnimation *rotationAnimation;
        
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
        
        rotationAnimation.duration = 25;
        
        rotationAnimation.delegate = self;
        
        rotationAnimation.repeatCount = MAXFLOAT;
        
        _rotationAnimation = rotationAnimation;
        
    }
    
    return _rotationAnimation;
}
-(void)hiddenView
{
    self.hidden = YES;
    self.isShowing = NO;
    [self.circleView.layer removeAllAnimations];
}
- (void)initItemDataArray
{

    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 4;
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = kLJHurmeBoldFont(14);//字体大小
    self.titleLabel.labelSpacing = 40; // 开始和结束标签之间的距离
    self.titleLabel.pauseInterval = 1.0; // 一秒的停顿之后再开始滚动
    self.titleLabel.scrollSpeed = 30; // 每秒像素
    self.titleLabel.textAlignment = NSTextAlignmentCenter; // 不使用自动滚动时的中心文本
    self.titleLabel.fadeLength = 12.f;
    self.titleLabel.scrollDirection = LJLiveAutoScrollDirectionLeft;
    
    self.titleLabel.text = kLJLiveHelper.data.current.turntableTitle;
    
    [self.titleLabel observeApplicationNotifications];
    
    
    _luckyItemArray = [NSMutableArray array];
    
    NSArray * items = kLJLiveHelper.data.current.turntableItems;
    for (int i = 0; i < items.count ; i++) {
        LJLiveTurntableViewModel *model = [[LJLiveTurntableViewModel alloc] init];
        if (items.count > i) {
            NSString * name = items[i];
            model.remark = name;
            model.index = i;
            model.displayIndex = i;
            model.imageName = nil;
            [_luckyItemArray addObject:model];
        }
    }
    [_luckyItemArray sortUsingComparator:^NSComparisonResult(LJLiveTurntableViewModel *  _Nonnull obj1, LJLiveTurntableViewModel *  _Nonnull obj2) {
        return obj1.displayIndex>obj2.displayIndex;
    }];
}
- (void)animationDidStart:(CAAnimation *)theAnimation {
    
    //动画开始了
    LJLog(@"动画开始");
    
}
-(void)showView
{
    self.hidden = NO;
    if (self.isAnimation) return;
    self.isShowing = YES;
    [self.circleView.layer addAnimation:self.rotationAnimation forKey:@"autoRotationAnimation"];
}
-(void)reciveTurnPlateInfoData:(NSDictionary*)dic {
    
    //转盘开关
    kLJLiveHelper.data.current.turntableFlag = [[dic objectForKey:@"turnTableIsOpen"] integerValue];
    //转盘title
    kLJLiveHelper.data.current.turntableTitle = ([[dic objectForKey:@"turnTableTitle"] isKindOfClass:NSNull.class]||[dic objectForKey:@"turnTableTitle"] == nil) ? @"":[dic objectForKey:@"turnTableTitle"];
    //转盘数据
    kLJLiveHelper.data.current.turntableItems = ([[dic objectForKey:@"turnTableInfoList"] isKindOfClass:NSNull.class] || [dic objectForKey:@"turnTableInfoList"] == nil) ? @[]:[dic objectForKey:@"turnTableInfoList"];
    //选中数据
    NSInteger selectedIndex = [[dic objectForKey:@"selectedIndex"] integerValue];
    
    //主播关闭转盘
    if (kLJLiveHelper.data.current.turntableFlag == 2) {
        //隐藏转盘
        self.hiddenBlock();
    }
    
    //控制隐藏显示转盘小按钮
    self.hostCloseOpenTurnPlateBlock();
    
    [self initItemDataArray];
    
    //移除之前绘制的layer信息
    [self.circleView.layer removeAllSublayers];
    
    //更新转盘信息
    self.circleView.panBgColors = [self getColorsWithItems:self.luckyItemArray];
    
    self.circleView.luckyItemArray = self.luckyItemArray;
    //-1表示修改title或者转盘开关状态更改
    if (selectedIndex != -1) {
        self.selectedIndex = selectedIndex;
        [self startAction];
    }
}
-(void)startAction {
    
    [self.circleView.layer removeAllAnimations];
    
    //如果转盘正在旋转，不做任何操作
    if (self.isAnimation) {
        return;
    }
    
    self.isAnimation = YES;
    
    self.curItem = [self getItemByIndex:self.selectedIndex];
    
    if (self.curItem) {
        LJLiveTurntableViewModel * item = [self getItemByIndex:self.curItem.index];
        if (item) {
            LJLog(@"奖品应该是：%@",item);
            [self.circleView turntableRotateToDisplayIndex:item.displayIndex];
        }else{
            LJLog(@"没有此奖品");
        }
    }
    
}
@end
