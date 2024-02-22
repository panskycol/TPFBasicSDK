//
//  UIView+UIView_FrameExtend.h
//  FireflyShow
//
//  Created by Jim Chan on 16/3/30.
//  Copyright © 2016年 最帅开发团队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameExtend)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;


@end

@interface UIScrollView (FrameExtend)

@property (nonatomic) CGFloat offsetX;
@property (nonatomic) CGFloat offsetY;

// 动画抖动效果
+ (void)addAnimationShakeToView:(UIView *)target;

@end
