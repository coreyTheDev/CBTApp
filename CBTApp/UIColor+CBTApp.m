//
//  UIColor+CBTApp.m
//  CBTApp
//
//  Created by Corey Zanotti on 12/2/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import "UIColor+CBTApp.h"

@implementation UIColor(CBTApp)
+(UIColor *)cbtRed
{
    return [UIColor colorWithRed:1.0 green:32/255. blue:36/255. alpha:1.0];
}
+(UIColor *)cbtLightGreen
{
    return [UIColor colorWithRed:88/255.0 green:232/255.0 blue:219/255.0 alpha:1.0];
}
+(UIColor *)cbtGray
{
    return [UIColor colorWithRed:225/255.0 green:231/255.0 blue:242/255.0 alpha:1.0];
}
+(UIColor *)cbtDarkGay
{
    return [UIColor colorWithRed:72/255. green:72/255. blue:71/255. alpha:1.0];
}
@end
