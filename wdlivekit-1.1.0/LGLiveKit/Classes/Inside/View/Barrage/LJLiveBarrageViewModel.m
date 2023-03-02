//
//  LJLiveBarrageViewModel.m
//  Woohoo
//
//  Created by M2-mini on 2021/10/12.
//

#import "LJLiveBarrageViewModel.h"

@implementation LJLiveBarrageViewModel


#pragma mark - Public







- (BOOL)isVip
{
    return self.barrage.isVip;
}
- (NSAttributedString *)lj_svipUniqueTagText
{
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    // VIP
    if (self.isVip || self.isSvip) {
        UIImage *image = self.isSvip ? kLJImageNamed(@"lj_live_tag_svip") : kLJImageNamed(@"lj_live_tag_vip");
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = image;
        attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attach];
        [attText appendAttributedString:imageText];
        [attText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    // UniqueTag
    if (self.barrage.uniqueTagUrl.length > 0) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.barrage.uniqueTagUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        }];
        
        UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:self.barrage.uniqueTagUrl]]];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = image ?: kLJImageNamed(@"lj_tag_default_icon");
        CGFloat height = image.size.width * 14/image.size.height;
        attach.bounds = image ? CGRectMake(0, -1.5, height, 14) : CGRectMake(0, 0, 30, 14);
        
        NSAttributedString *tagText = [NSAttributedString attributedStringWithAttachment:attach];
        [attText appendAttributedString:tagText];
        [attText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    return attText;
}
- (LJLiveBarrageType)barrageType
{
    return self.barrage.type;
}
- (void)lj_styleCalculate
{
    // 需要显示的消息
    if (self.barrage.lj_isDisplayedBarrage) {
        NSString *content;
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:(kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? @"\u202B" : @"\u202A"];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paraStyle.hyphenationFactor = 1;
        paraStyle.alignment = (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? NSTextAlignmentRight : NSTextAlignmentLeft;
        // 系统消息（3s）
        if (self.barrage.lj_isSystemBarrage) {
            // join
            if (self.barrage.type == LJLiveBarrageTypeJoinLive) {
                // VIP + UniqueTag
                [attText appendAttributedString:[self lj_svipUniqueTagText]];
            }
            // mute icon
            if (self.barrage.type == LJLiveBarrageTypeBeMute) {
                UIImage *image = kLJImageNamed(@"lj_live_barrage_mic_icon");
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                attach.image = image;
                attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attach];
                [attText appendAttributedString:imageText];
                [attText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }
            CGSize size1 = [attText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            // name
            NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.barrage.userName, (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? @"\u202B" : @"\u202A"] attributes:@{
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.6],
                NSFontAttributeName: kLJHurmeBoldFont(14)
            }];
            [attText appendAttributedString:nameText];
            // content
            if (self.barrage.type == LJLiveBarrageTypeJoinLive) {
                content = kLJLocalString(@"Join the room");
                NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:content attributes:@{
                    NSForegroundColorAttributeName: UIColor.whiteColor,
                    NSFontAttributeName: kLJHurmeBoldFont(14)
                }];
                [attText appendAttributedString:msgText];
            }
            // mute
            if (self.barrage.type == LJLiveBarrageTypeBeMute) {
                content = kLJLocalString(@"has been muted!");
                NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:content attributes:@{
                    NSForegroundColorAttributeName: kLJHexColor(0x57F0FF),
                    NSFontAttributeName: kLJHurmeBoldFont(14)
                }];
                [attText appendAttributedString:msgText];
            }
            // content size
            [attText addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, attText.length)];
            CGSize size2 = [attText boundingRectWithSize:CGSizeMake(kLJWidthScale(256)-12-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            self.contentSize = CGSizeMake(ceil(size2.width) + 12 + 8, MAX(ceil(size2.height) + 6 + 5, 24));
            // name button size
            CGSize size3 = [nameText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            self.nameButtonRect = CGRectMake(size1.width, 0, size3.width + 8, 28);
        } else {
            // hint textMsg gift
            if (self.barrage.type == LJLiveBarrageTypeHint) {
                // hint
                attText = [[NSMutableAttributedString alloc] initWithString:self.barrage.content attributes:@{
                    NSForegroundColorAttributeName: kLJHexColor(0xFFF378),
                    NSFontAttributeName: kLJHurmeBoldFont(14)
                }];
                CGSize size = [attText boundingRectWithSize:CGSizeMake(kLJWidthScale(256)-12-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                self.contentSize = CGSizeMake(ceil(size.width) + 12, MAX(ceil(size.height) + 6, 24));
            } else {
                // VIP + UniqueTag
                [attText appendAttributedString:[self lj_svipUniqueTagText]];
                CGSize size1 = [attText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                // name
                NSString *tag = self.barrage.type == LJLiveBarrageTypeTextMessage ? @":" : @"";
                NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ %@", self.barrage.userName, tag, (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? @"\u202B" : @"\u202A"] attributes:@{
                    NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.6],
                    NSFontAttributeName: kLJHurmeBoldFont(14)
                }];
                [attText appendAttributedString:nameText];
                // text
                if (self.barrage.type == LJLiveBarrageTypeTextMessage) {
                    // 敏感词屏蔽
                    NSString *content = @"";
                    if ([kLJLiveManager.dataSource respondsToSelector:@selector(lj_sensitiveReplaceByText:)]) {
                        content = [kLJLiveManager.dataSource lj_sensitiveReplaceByText:self.barrage.content];
                    } else {
                        content = self.barrage.content;
                    }
                    NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:content attributes:@{
                        NSForegroundColorAttributeName: UIColor.whiteColor,
                        NSFontAttributeName: kLJHurmeBoldFont(14)
                    }];
                    [attText appendAttributedString:msgText];
                }
                // gift
                if (self.barrage.type == LJLiveBarrageTypeGift) {
                    NSString *tag = @"'%@-@-@%'";
                    if (self.barrage.isblindBox) {
                        content = [NSString stringWithFormat:kLJLocalString(@"Send a %@ by Lucky Box"), tag];
                    } else {
                        content = [NSString stringWithFormat:kLJLocalString(@"Send a %@"), tag];
                    }
                    NSMutableAttributedString *msgText = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
                        NSForegroundColorAttributeName: kLJHexColor(0xFFEF7E),
                        NSFontAttributeName: kLJHurmeBoldFont(14)
                    }];
                    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                    attach.image = kLJImageNamed(@"lj_icon_default_gift");
                    attach.bounds = CGRectMake(0, -10, 30, 30);
                    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:[self lj_giftUrl]] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        attach.image = image;
                        attach.bounds = CGRectMake(0, -10, 30, 30);
                    }];
                    NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:attach];
                    NSRange range = [content rangeOfString:tag];
                    [msgText replaceCharactersInRange:range withAttributedString:attachment];
                    [attText appendAttributedString:msgText];
                }
                // content size
                [attText addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, attText.length)];
                CGSize size2 = [attText boundingRectWithSize:CGSizeMake(kLJWidthScale(256)-12-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                self.contentSize = CGSizeMake(ceil(size2.width) + 12 + 8, MAX(ceil(size2.height) + 6 + 5, 24));
                // name button size
                CGSize size3 = [nameText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                self.nameButtonRect = CGRectMake(size1.width, 0, size3.width + 8, 28);
            }
        }
        self.barrageText = attText;
    }
}
- (NSString * __nullable)lj_giftUrl
{
    NSString *giftImageUrl = @"";
    LJLiveGift *giftConfig;
    NSArray *giftConfigs = kLJLiveManager.inside.accountConfig.liveConfig.giftConfigs;//模型转换
    for (LJLiveGift *config in giftConfigs) {
        if (config.giftId == self.barrage.giftId) {
            giftConfig = config;
            break;
        }
    }
    // 兼容老版本礼物
    if (!giftConfig) {
        NSArray *giftConfigs = kLJLiveManager.inside.accountConfig.liveConfig.videoChatRoomReplacedGiftConfigs;
        for (LJLiveGift *config in giftConfigs) {
            if (config.giftId == self.barrage.giftId) {
                giftConfig = config;
                break;
            }
        }
    }
    if (giftConfig) giftImageUrl = giftConfig.iconUrl;
    return giftImageUrl;
}
- (instancetype)initWithBarrage:(LJLiveBarrage *)barrage
{
    self = [super init];
    if (self) {
        self.barrage = barrage;
        self.isSvip = barrage.isSvip;
        self.isVip = barrage.isVip;
        [self lj_styleCalculate];
    }
    return self;
}
- (BOOL)isSvip
{
    return self.barrage.isSvip;
}
@end
