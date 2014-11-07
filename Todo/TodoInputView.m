//
//  TodoInputView.m
//  Todo
//
//  Created by Yu Cong on 14-11-7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#define duration 0.55

#define sideViewDamping 0.9
#define sideViewVelocity 10

#define centerViewDamping 1.0
#define centerViewVelocity 8

#import "TodoInputView.h"
#import "Settings.h"

@interface TodoInputView()
@property (strong, nonatomic) IBOutlet UIView *containerView;

@property(nonatomic,strong) UIView* sideHelperView;
@property(nonatomic,strong) UIView* centerHelperView;
@property(nonatomic,strong) CADisplayLink *displayLink;

@property int counter;
@property CGFloat height;
@end

@implementation TodoInputView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"TodoInputView" owner:self options:nil];
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview: self.containerView];
        [self setup];
    }
    return self;
}

-(void) setup
{
    self.counter = 0;
    self.height = CGRectGetHeight(self.bounds);

    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.height);
    
    self.sideHelperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.sideHelperView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.sideHelperView];
    
    
    self.centerHelperView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2, 0, 0, 0)];
    self.centerHelperView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.centerHelperView];
    
    self.backgroundColor=[UIColor clearColor];
}

-(void) toggle
{
    if(self.shown){
        [self hide];
    }else{
        [self show];
    }
}



-(void) hide
{
    if(self.counter!=0){
        return;
    }
    self.shown=NO;
    [self start];
    [self animateSideHelperViewToPoint:CGPointMake(self.sideHelperView.center.x, 0)];
    [self animateCenterHelperViewToPoint: CGPointMake(self.centerHelperView.center.x, 0)];
    [self animateContentViewToHeight:-self.height];
    
    [self.inputField resignFirstResponder];
    
}

-(void) show
{
    if(self.counter!=0){
        return;
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.shown=YES;
    [self start];
    CGFloat height = CGRectGetHeight(self.bounds);
    
    [self animateSideHelperViewToPoint:CGPointMake(self.sideHelperView.center.x, height)];
    [self animateCenterHelperViewToPoint: CGPointMake(self.centerHelperView.center.x, height)];
    [self animateContentViewToHeight:0];
    [self.inputField becomeFirstResponder];
    
}

-(void) animateSideHelperViewToPoint:(CGPoint) point
{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:sideViewDamping initialSpringVelocity:sideViewVelocity options:0 animations:^{
        self.sideHelperView.center = point;
    } completion:^(BOOL finished) {
        [self complete];
        
    }];
}


-(void) animateCenterHelperViewToPoint:(CGPoint) point
{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:centerViewDamping initialSpringVelocity:centerViewVelocity options:0 animations:^{
        self.centerHelperView.center = point;
        
    } completion:^(BOOL finished) {
        [self complete];
    }];
}

-(void) animateContentViewToHeight:(CGFloat) height
{
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:centerViewDamping initialSpringVelocity:centerViewVelocity options:0 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, height);
    } completion:^(BOOL finished) {
    }];
}




-(void) tick:(CADisplayLink*) displayLink
{
    //NSLog(@"%@", NSStringFromCGPoint(self.centerHelperView.center));
    [self  setNeedsDisplay];
}

-(void) start
{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
        self.counter=2;
    }
}

-(void) complete
{
    self.counter--;
    if(self.counter==0){
        [self.displayLink invalidate];
        self.displayLink = nil;
        if(!self.shown){
            [self removeFromSuperview];
        }
    }
}
- (void)drawRect:(CGRect)rect
{
    if(self.counter==0){
        return;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenRect);
    
    CALayer* sideLayer=self.sideHelperView.layer.presentationLayer;
    CGPoint sidePoint=sideLayer.frame.origin;
    
    CALayer* centerLayer =self.centerHelperView.layer.presentationLayer;
    CGPoint centerPoint=centerLayer.frame.origin;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [[Settings themeColor] setFill];
    
    [path moveToPoint:sidePoint];
    [path addQuadCurveToPoint:CGPointMake(screenWidth, sidePoint.y) controlPoint:centerPoint];
    [path addLineToPoint:CGPointMake(screenWidth,0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    
    [path fill];
}


@end
