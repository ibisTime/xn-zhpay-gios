//
//  UIColor+theme.m
//  ZHBGift
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "UIColor+theme.h"

@implementation UIColor (theme)

+ (UIColor *)shopThemeColor {

    return [UIColor colorWithHexString:@"#f05567"];

}

+ (UIColor *)goodsThemeColor {
    
    return [UIColor colorWithHexString:@"#de4355"];
    
}

+ (UIColor *)billThemeColor {
    
    return [UIColor colorWithHexString:@"#ec573f"];
}

+ (UIColor *)orderThemeColor {
    
    return [UIColor colorWithHexString:@"#ff6e53"];
}

+ (UIColor *)accountSettingThemeColor {
    
    return [UIColor colorWithHexString:@"#f8bc44"];
}


////
//UIColor *color1 = [UIColor colorWithHexString:@"#f05567"];
//UIColor *color2 = [UIColor colorWithHexString:@"#de4355"];
//UIColor *color3 = [UIColor colorWithHexString:@"#ff6e53"];
//UIColor *color4 = [UIColor colorWithHexString:@"#ec573f"];
//UIColor *color5 = [UIColor colorWithHexString:@"#f8bc44"];
////




+ (UIColor *)zh_themeColor {

    return [UIColor colorWithHexString:@"#fe4332"];

}

+ (UIColor *)zh_textColor {

    return [UIColor colorWithHexString:@"#484848"];
}
+ (UIColor *)zh_textColor2 {
    
    return [UIColor colorWithHexString:@"#999999"];
}


+ (UIColor *)zh_lineColor {
    
    return [UIColor colorWithHexString:@"#eeeeee"];
}




+ (UIColor *)themeColor {

    return [UIColor colorWithHexString:@"#f05567"];
    
}

+ (UIColor *)textColor {

    return [UIColor zh_textColor];
}

+ (UIColor *)textColor2 {

    return [UIColor zh_textColor2];

}

+ (UIColor *)lineColor {

    return [UIColor zh_lineColor];

}



@end
