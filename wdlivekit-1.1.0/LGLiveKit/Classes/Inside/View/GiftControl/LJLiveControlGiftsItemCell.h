//
//  LJLiveControlGiftsItemCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveControlGiftsItemCell : UICollectionViewCell







@property (nonatomic, copy) LJLiveVoidBlock sendGiftBlock;
@property (nonatomic, copy) LJLiveVoidBlock clickBlindboxDetail;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *topRightButton;
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;
@property (nonatomic, strong) LJLiveGift *giftConfig;
@end

NS_ASSUME_NONNULL_END
