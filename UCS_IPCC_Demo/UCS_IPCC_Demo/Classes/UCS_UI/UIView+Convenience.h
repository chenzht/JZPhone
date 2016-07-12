//
//  UIView+Convenience.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Convenience)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

- (BOOL)containsSubView:(UIView *)subView;
//- (BOOL)containsSubViewOfClassType:(Class)class;
- (void)removeAllSubViews;

@end
