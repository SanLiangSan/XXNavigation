//
//  XXViewController.m
//  XXNavigationController
//
//  Created by Tracy on 14-3-5.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "XXViewController.h"
#import "XXNavigationController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface XXViewController ()

@end

@implementation XXViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // -----------------------------------------------------------------------
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,MainScreenWidth,MainScreenHeight}];
    [self.view addSubview:imageView];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"标题%lu",(unsigned long)self.navigationController.viewControllers.count];
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count % 2 == 0) {
        imageView.image = [UIImage imageNamed:@"image_0.JPG"];
    } else {
        imageView.image = [UIImage imageNamed:@"image_1.JPG"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
	// Do any additional setup after loading the view.
}

- (void)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)push:(id)sender {
    XXViewController *viewC = [[XXViewController alloc] init];
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)tap:(UITapGestureRecognizer *)tapGesture {
    [self push:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
