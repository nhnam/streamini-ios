//
//  UIView+Loding.h
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EaseLoadingView;

@interface UIView (Loding)
@property (strong, nonatomic) EaseLoadingView *loadingView;
@property (assign, nonatomic, readonly) BOOL isEALoading;
- (void)beginLoading;
- (void)endLoading;
@end

@interface EaseLoadingView : UIView
@property (strong, nonatomic) UIImageView *loopView, *logoView;
@property (assign, nonatomic, readonly) BOOL isLoading;
- (void)startAnimating;
- (void)stopAnimating;
@end