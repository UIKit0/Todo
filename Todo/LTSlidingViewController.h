//
//  LTSlidingContainerViewController.h
//  PageViewControllerTest
//
//  Created by ltebean on 14/10/31.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSlidingView.h"

@interface LTSlidingViewController : UIViewController
@property(nonatomic,strong) id<LTSlidingViewTransition> animator;

@end
