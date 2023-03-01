//
//  GYLiveBarrageCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveBarrageCell : UITableViewCell

@property (nonatomic, strong) GYLiveBarrageViewModel *viewModel;

@property (nonatomic, copy) GYLiveVoidBlock nameBlock;

@end

NS_ASSUME_NONNULL_END
