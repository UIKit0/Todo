//
//  LTSlideView.h
//  PageViewControllerTest
//
//  Created by ltebean on 14/10/31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SlideDirection) {
    left,
    right
};

@protocol LTSlidingViewTransition <NSObject>
-(void) updateSourceView:(UIView*) sourceView destinationView:(UIView*) destView withPercent:(CGFloat)percent direction:(SlideDirection)direction;
@end

@interface LTSlidingView : UIView
@property(nonatomic,strong) id<LTSlidingViewTransition> animator;
-(void) addView:(UIView*) view;
@end
