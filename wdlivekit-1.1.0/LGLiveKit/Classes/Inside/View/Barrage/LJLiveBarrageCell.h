//
//  LJLiveBarrageCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBarrageCell : UITableViewCell

@property (nonatomic, strong) LJLiveBarrageViewModel *viewModel;

@property (nonatomic, copy) LJLiveVoidBlock nameBlock;

@end

NS_ASSUME_NONNULL_END
