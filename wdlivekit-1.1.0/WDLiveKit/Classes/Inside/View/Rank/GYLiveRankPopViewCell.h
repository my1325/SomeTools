//
//  GYLiveRankPopViewCell.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveRankPopViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *rankLabel;

@property (nonatomic, strong) GYLiveRoomMember *member;

@property (nonatomic, copy) GYLiveVoidBlock avatarBlock;

@end

NS_ASSUME_NONNULL_END
