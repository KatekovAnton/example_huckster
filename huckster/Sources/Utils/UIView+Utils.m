//
//  UIView+Utils.m
//  huckster
//
//  Created by Katekov Anton on 2/13/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import "UIView+Utils.h"



@implementation UIImage (Utils)

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextClearRect(UIGraphicsGetCurrentContext(), view.bounds);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
