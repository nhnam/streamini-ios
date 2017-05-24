//
//  UIView+Loding.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kLoading_LoopName @"loading_loop"
#define kLoading_LogoName @"loading_logo"

#import "UIView+Loding.h"
#import <objc/runtime.h>

static char LoadingViewKey;

@implementation UIView (Loding)
- (void)setLoadingView:(EaseLoadingView *)loadingView{
    [self willChangeValueForKey:@"LoadingViewKey"];
    objc_setAssociatedObject(self, &LoadingViewKey,
                             loadingView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"LoadingViewKey"];
}
- (EaseLoadingView *)loadingView{
    return objc_getAssociatedObject(self, &LoadingViewKey);
}
- (BOOL)isEALoading{
    return self.loadingView? self.loadingView.isLoading: NO;
}
- (void)beginLoading{
    if (!self.loadingView) { //初始化LoadingView
        self.loadingView = [[EaseLoadingView alloc] initWithFrame:self.bounds];
    }
    [self addSubview:self.loadingView];
    self.loadingView.frame = self.bounds;
    [self.loadingView startAnimating];
}

- (void)endLoading{
    if (self.loadingView) {
        [self.loadingView stopAnimating];
    }
}
@end


@interface EaseLoadingView ()
@property (nonatomic, assign) CGFloat loopAngle, monkeyAlpha, angleStep, alphaStep;
@end


@implementation EaseLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _loopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kLoading_LoopName]];
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kLoading_LogoName]];
        _loopView.alpha = 0.8;
        [_loopView setCenter:self.center];
        [_logoView setCenter:self.center];
        [self addSubview:_loopView];
        [self addSubview:_logoView];
        
        _loopAngle = 0.0;
        _monkeyAlpha = 1.0;
        _angleStep = 360/3;
        _alphaStep = 0.9/6.0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_loopView setCenter:self.center];
    [_logoView setCenter:self.center];
}

- (void)startAnimating{
    self.hidden = NO;
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    [self loadingAnimation];
}

- (void)stopAnimating{
    self.hidden = YES;
    _isLoading = NO;
}

- (void)loadingAnimation{
    static CGFloat duration = 0.25f;
    _loopAngle += _angleStep;
    if (_monkeyAlpha >= 1.0 || _monkeyAlpha <= 0.1) {
        _alphaStep = -_alphaStep;
    }
    _monkeyAlpha += _alphaStep;
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform loopAngleTransform = CGAffineTransformMakeRotation(_loopAngle * (M_PI / 180.0f));
        _loopView.transform = loopAngleTransform;
        _logoView.alpha = _monkeyAlpha;
    } completion:^(BOOL finished) {
        if (_isLoading && [self superview] != nil) {
            [self loadingAnimation];
        }else{
            [self removeFromSuperview];
            
            _loopAngle = 0.0;
            _monkeyAlpha = 1.0;
            _alphaStep = ABS(_alphaStep);
            CGAffineTransform loopAngleTransform = CGAffineTransformMakeRotation(_loopAngle * (M_PI / 180.0f));
            _loopView.transform = loopAngleTransform;
        }
    }];
}

@end