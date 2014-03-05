//
//  XXViewController.m
//  XXNavigationController
//
//  Created by Tracy on 14-3-5.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "XXViewController.h"
#import "XXNavigationController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,0,320,100}];
    label.center = CGPointMake(160,230);
    [self.view addSubview:label];
    NSMutableString *string  = [NSMutableString string];
    for (int i = 0; i < 50; i ++) {
        [string appendFormat:@"%d",self.navigationController.viewControllers.count];
    }
    label.text = @"sadfasdfsadfewejlkjuhwoiqjoi1234567891";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"标题%d",self.navigationController.viewControllers.count];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = (CGRect){88,250,60,30};
    [button setTitle:@"push" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = (CGRect){38,250,60,30};
    [button1 setTitle:@"pop" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
}

- (void)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)push:(id)sender {
    XXViewController *viewC = [[XXViewController alloc] init];
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
