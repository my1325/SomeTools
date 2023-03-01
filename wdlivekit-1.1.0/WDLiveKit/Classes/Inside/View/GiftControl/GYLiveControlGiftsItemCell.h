//
//  GYLiveControlGiftsItemCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveControlGiftsItemCell : UICollectionViewCell

@property (nonatomic, strong) GYLiveGift *giftConfig;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;

@property (weak, nonatomic) IBOutlet UIButton *topRightButton;

@property (nonatomic, copy) GYLiveVoidBlock clickBlindboxDetail;

@property (nonatomic, copy) GYLiveVoidBlock sendGiftBlock;

@end

NS_ASSUME_NONNULL_END
