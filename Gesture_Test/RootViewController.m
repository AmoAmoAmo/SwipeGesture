//
//  RootViewController.m
//  Gesture_Test
//
//  Created by Josie on 2017/7/9.
//  Copyright © 2017年 Josie. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ViewController *vc = [[ViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
