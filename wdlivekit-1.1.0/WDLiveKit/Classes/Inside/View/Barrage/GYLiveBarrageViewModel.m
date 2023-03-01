//
//  GYLiveBarrageViewModel.m
//  Woohoo
//
//  Created by M2-mini on 2021/10/12.
//

#import "GYLiveBarrageViewModel.h"

@implementation GYLiveBarrageViewModel

- (instancetype)initWithBarrage:(GYLiveBarrage *)barrage
{
    self = [super init];
    if (self) {
        self.barrage = barrage;
        self.isSvip = barrage.isSvip;
        self.isVip = barrage.isVip;
        [self fb_styleCalculate];
    }
    return self;
}

#pragma mark - Public

- (NSAttributedString *)fb_svipUniqueTagText
{
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    // VIP
    if (self.isVip || self.isSvip) {
        UIImage *image = self.isSvip ? kGYImageNamed(@"fb_live_tag_svip") : kGYImageNamed(@"fb_live_tag_vip");
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
        attach.image = image ?: kGYImageNamed(@"fb_tag_default_icon");
        CGFloat height = image.size.width * 14/image.size.height;
        attach.bounds = image ? CGRectMake(0, -1.5, height, 14) : CGRectMake(0, 0, 30, 14);
        
        NSAttributedString *tagText = [NSAttributedString attributedStringWithAttachment:attach];
        [attText appendAttributedString:tagText];
        [attText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    return attText;
}

- (NSString * __nullable)fb_giftUrl
{
    NSString *giftImageUrl = @"";
    GYLiveGift *giftConfig;
    NSArray *giftConfigs = kGYLiveManager.inside.accountConfig.liveConfig.giftConfigs;//模型转换
    for (GYLiveGift *config in giftConfigs) {
        if (config.giftId == self.barrage.giftId) {
            giftConfig = config;
            break;
        }
    }
    // 兼容老版本礼物
    if (!giftConfig) {
        NSArray *giftConfigs = kGYLiveManager.inside.accountConfig.liveConfig.videoChatRoomReplacedGiftConfigs;
        for (GYLiveGift *config in giftConfigs) {
            if (config.giftId == self.barrage.giftId) {
                giftConfig = config;
                break;
            }
        }
    }
    if (giftConfig) giftImageUrl = giftConfig.iconUrl;
    return giftImageUrl;
}

- (void)fb_styleCalculate
{
    // 需要显示的消息
    if (self.barrage.fb_isDisplayedBarrage) {
        NSString *content;
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:(kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? @"\u202B" : @"\u202A"];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paraStyle.hyphenationFactor = 1;
        paraStyle.alignment = (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? NSTextAlignmentRight : NSTextAlignmentLeft;
        // 系统消息（3s）
        if (self.barrage.fb_isSystemBarrage) {
            // join
            if (self.barrage.type == GYLiveBarrageTypeJoinLive) {
                // VIP + UniqueTag
                [attText appendAttributedString:[self fb_svipUniqueTagText]];
            }
            // mute icon
            if (self.barrage.type == GYLiveBarrageTypeBeMute) {
                UIImage *image = kGYImageNamed(@"fb_live_barrage_mic_icon");
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                attach.image = image;
                attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attach];
                [attText appendAttributedString:imageText];
                [attText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }
            CGSize size1 = [attText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            // name
            NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", self.barrage.userName, (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? @"\u202B" : @"\u202A"] attributes:@{
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.6],
                NSFontAttributeName: kGYHurmeBoldFont(14)
            }];
            [attText appendAttributedString:nameText];
            // content
            if (self.barrage.type == GYLiveBarrageTypeJoinLive) {
                content = kGYLocalString(@"Join the room");
                NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:content attributes:@{
                    NSForegroundColorAttributeName: UIColor.whiteColor,
                    NSFontAttributeName: kGYHurmeBoldFont(14)
                }];
                [attText appendAttributedString:msgText];
            }
            // mute
            if (self.barrage.type == GYLiveBarrageTypeBeMute) {
                content = kGYLocalString(@"has been muted!");
                NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:content attributes:@{
                    NSForegroundColorAttributeName: kGYHexColor(0x57F0FF),
                    NSFontAttributeName: kGYHurmeBoldFont(14)
                }];
                [attText appendAttributedString:msgText];
            }
            // content size
            [attText addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, attText.length)];
            CGSize size2 = [attText boundingRectWithSize:CGSizeMake(kGYWidthScale(256)-12-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            self.contentSize = CGSizeMake(ceil(size2.width) + 12 + 8, MAX(ceil(size2.height) + 6 + 5, 24));
            // name button size
            CGSize size3 = [nameText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            self.nameButtonRect = CGRectMake(size1.width, 0, size3.width + 8, 28);
        } else {
            // hint textMsg gift
            if (self.barrage.type == GYLiveBarrageTypeHint) {
                // hint
                attText = [[NSMutableAttributedString alloc] initWithString:self.barrage.content attributes:@{
                    NSForegroundColorAttributeName: kGYHexColor(0xFFF378),
                    NSFontAttributeName: kGYHurmeBoldFont(14)
                }];
                CGSize size = [attText boundingRectWithSize:CGSizeMake(kGYWidthScale(256)-12-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                self.contentSize = CGSizeMake(ceil(size.width) + 12, MAX(ceil(size.height) + 6, 24));
            } else {
                // VIP + UniqueTag
                [attText appendAttributedString:[self fb_svipUniqueTagText]];
                CGSize size1 = [attText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                // name
                NSString *tag = self.barrage.type == GYLiveBarrageTypeTextMessage ? @":" : @"";
                NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ %@", self.barrage.userName, tag, (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? @"\u202B" : @"\u202A"] attributes:@{
                    NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.6],
                    NSFontAttributeName: kGYHurmeBoldFont(14)
                }];
                [attText appendAttributedString:nameText];
                // text
                if (self.barrage.type == GYLiveBarrageTypeTextMessage) {
                    // 敏感词屏蔽
                    NSString *content = @"";
                    if ([kGYLiveManager.dataSource respondsToSelector:@selector(fb_sensitiveReplaceByText:)]) {
                        content = [kGYLiveManager.dataSource fb_sensitiveReplaceByText:self.barrage.content];
                    } else {
                        content = self.barrage.content;
                    }
                    NSAttributedString *msgText = [[NSAttributedString alloc] initWithString:content attributes:@{
                        NSForegroundColorAttributeName: UIColor.whiteColor,
                        NSFontAttributeName: kGYHurmeBoldFont(14)
                    }];
                    [attText appendAttributedString:msgText];
                }
                // gift
                if (self.barrage.type == GYLiveBarrageTypeGift) {
                    NSString *tag = @"'%@-@-@%'";
                    if (self.barrage.isblindBox) {
                        content = [NSString stringWithFormat:kGYLocalString(@"Send a %@ by Lucky Box"), tag];
                    } else {
                        content = [NSString stringWithFormat:kGYLocalString(@"Send a %@"), tag];
                    }
                    NSMutableAttributedString *msgText = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
                        NSForegroundColorAttributeName: kGYHexColor(0xFFEF7E),
                        NSFontAttributeName: kGYHurmeBoldFont(14)
                    }];
                    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                    attach.image = kGYImageNamed(@"fb_icon_default_gift");
                    attach.bounds = CGRectMake(0, -10, 30, 30);
                    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:[self fb_giftUrl]] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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
                CGSize size2 = [attText boundingRectWithSize:CGSizeMake(kGYWidthScale(256)-12-3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                self.contentSize = CGSizeMake(ceil(size2.width) + 12 + 8, MAX(ceil(size2.height) + 6 + 5, 24));
                // name button size
                CGSize size3 = [nameText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                self.nameButtonRect = CGRectMake(size1.width, 0, size3.width + 8, 28);
            }
        }
        self.barrageText = attText;
    }
}

- (GYLiveBarrageType)barrageType
{
    return self.barrage.type;
}

- (BOOL)isSvip
{
    return self.barrage.isSvip;
}

- (BOOL)isVip
{
    return self.barrage.isVip;
}

@end
