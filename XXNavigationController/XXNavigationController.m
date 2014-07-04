//
//  XXNavigationController.m
//  XXNavigationController
//
//  Created by Tracy on 14-3-5.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "XXNavigationController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width



@interface XXNavigationController ()<UIGestureRecognizerDelegate> {
    CGPoint startPoint;

    UIImageView *lastScreenShotView;// view
}

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) NSMutableArray *screenShotList;

@property (nonatomic, assign) BOOL isMoving;

@end

static CGFloat offset_float = 0.65;// 拉伸参数
static CGFloat min_distance = 100;// 最小回弹距离

@implementation XXNavigationController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSMutableArray *)screenShotList {
    if (!_screenShotList) {
        _screenShotList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _screenShotList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 有动画用自己的动画
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        [self.screenShotList removeLastObject];
        return [super popViewControllerAnimated:animated];
    }
}

- (void) popAnimation {
    if (self.viewControllers.count == 1) {
        return;
    }
    if (!self.backGroundView) {
        CGRect frame = self.view.frame;
        
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        
        _backGroundView.backgroundColor = [UIColor blackColor];
        
    }
    
    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    
    _backGroundView.hidden = NO;
    
    if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotList lastObject];
    
    lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    
    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,MainScreenWidth,lastScreenShot.size.height};
    
    [self.backGroundView addSubview:lastScreenShotView];

    [UIView animateWithDuration:0.4 animations:^{
        
        [self moveViewWithX:MainScreenWidth];
        
    } completion:^(BOOL finished) {
        [self gestureAnimation:NO];
        
        CGRect frame = self.view.frame;
        
        frame.origin.x = 0;
        
        self.view.frame = frame;
        
        _isMoving = NO;
        
        self.backGroundView.hidden = YES;
    }];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotList addObject:[self capture]];
    [super pushViewController:viewController animated:animated];
}


#pragma mark - Utility Methods -
// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position when paning
- (void)moveViewWithX:(float)x
{
    x = x>MainScreenWidth?MainScreenWidth:x;
    
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    // TODO
    lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float)+x*offset_float,0,MainScreenWidth,lastScreenShotView.frame.size.height};
}

- (void)gestureAnimation:(BOOL)animated {
    [self.screenShotList removeLastObject];
    [super popViewControllerAnimated:animated];
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        
        startPoint = touchPoint;
        
        if (!self.backGroundView) {
            CGRect frame = self.view.frame;
            
            _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            
            _backGroundView.backgroundColor = [UIColor blackColor];
            
        }
        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
        
        _backGroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotList lastObject];
        
        lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        
        lastScreenShotView.frame = (CGRect){-(MainScreenWidth*offset_float),0,MainScreenWidth,lastScreenShot.size.height};
        
        [self.backGroundView addSubview:lastScreenShotView];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startPoint.x > min_distance)
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                [self moveViewWithX:MainScreenWidth];
                
            } completion:^(BOOL finished) {
                [self gestureAnimation:NO];
                
                CGRect frame = self.view.frame;
                
                frame.origin.x = 0;
                
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                
                self.backGroundView.hidden = YES;
            }];
            
        }
        return;
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            
            self.backGroundView.hidden = YES;
        }];
        
        return;
    }
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startPoint.x];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
