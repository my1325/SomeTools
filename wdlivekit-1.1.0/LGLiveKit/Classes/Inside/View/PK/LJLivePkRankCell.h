//
//  LJLivePkRankCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkRankCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) LJLivePkTopFan *fan;
@property (nonatomic, copy) LJLiveVoidBlock avatarBlock;
@end

NS_ASSUME_NONNULL_END
