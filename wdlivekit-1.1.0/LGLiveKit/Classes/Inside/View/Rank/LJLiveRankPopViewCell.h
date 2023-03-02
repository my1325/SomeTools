//
//  LJLiveRankPopViewCell.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRankPopViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *rankLabel;

@property (nonatomic, strong) LJLiveRoomMember *member;

@property (nonatomic, copy) LJLiveVoidBlock avatarBlock;

@end

NS_ASSUME_NONNULL_END
