//
//  UIFont+LJLiveAdd.m
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import "UIFont+LJLiveAdd.h"
#import <CoreText/CTFontManager.h>

@implementation UIFont (LJLiveAdd)

+ (UIFont *)lj_hurmeRegularFontOfSize:(CGFloat)size
{
    NSString *fontName = @"HurmeGeometricSans1-Regular";
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        [self dynamicallyLoadFontNamed:fontName type:@"otf"];
        font = [UIFont fontWithName:fontName size:size];
        if (!font) {
            font = [UIFont systemFontOfSize:size];
        }
    }
    return font;
}

+ (UIFont *)lj_hurmeBoldFontOfSize:(CGFloat)size
{
    NSString *fontName = @"HurmeGeometricSans1-Bold";
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        [self dynamicallyLoadFontNamed:fontName type:@"otf"];
        font = [UIFont fontWithName:fontName size:size];
        if (!font) {
            font = [UIFont systemFontOfSize:size];
        }
    }
    return font;
}

+ (void)dynamicallyLoadFontNamed:(NSString *)fontName type:(NSString *)type
{
    NSString *path = [kLJLiveBundle pathForResource:fontName ofType:type];
    NSData *fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    if (fontData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

@end
