//
//  ViewController.m
//  Gesture_Test
//
//  Created by Josie on 2017/7/4.
//  Copyright © 2017年 Josie. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"


#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

#define Y1               50
#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 64


@interface ViewController ()<UIGestureRecognizerDelegate>


@property (nonatomic, strong) SecondViewController      *vc;

// 用来显示阴影的view，里面装的是self.vc.view
@property (nonatomic, strong) UIView                    *shadowView;

@property (nonatomic, strong) UISwipeGestureRecognizer  *swipe1;

@property (nonatomic, strong) UIPanGestureRecognizer    *pan;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self addChildViewController:self.vc];
    [self.shadowView addSubview:self.vc.view];
    [self.view addSubview:self.shadowView];

    [self.vc didClickTextField:^{
        
//        NSLog(@"receive-----------");
        [UIView animateWithDuration:0.4 animations:^{
            
            self.shadowView.frame = CGRectMake(0, 50, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }completion:^(BOOL finished) {
            // 呼出键盘。  一定要在动画结束后调用，否则会出错
            [self.vc.searchController.searchBar becomeFirstResponder];
        }];
        // 更新offsetY
        self.vc.offsetY = self.shadowView.frame.origin.y;
        
    }];
}





// table可滑动时，swipe默认不再响应 所以要打开
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    float offsetY = self.shadowView.frame.origin.y; // 这是上一次Y的位置
//    NSLog(@"==== === %f == =====",self.vc.table.contentOffset.y);

    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
//        NSLog(@"==== down =====");
        
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.vc.table.contentOffset.y == 0) {
            self.vc.table.scrollEnabled = NO;
        }
        
        if (offsetY >= Y1 && offsetY < Y2) {
            // 停在y2的位置
            stopY = Y2;
        }else if (offsetY >= Y2 ){
            // 停在y3的位置
            stopY = Y3;
        }else{
            stopY = Y1;
        }
        animateY = stopY + margin;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
//        NSLog(@"==== up =====");
        
        if (offsetY <= Y2) {
            // 停在y1的位置
            stopY = Y1;
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
            self.vc.table.scrollEnabled = YES;
        }else if (offsetY > Y2 && offsetY <= Y3 ){
            // 停在y2的位置
            stopY = Y2;
        }else{
            stopY = Y3;
        }
        animateY = stopY - margin;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.shadowView.frame = CGRectMake(0, animateY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    // 记录shadowView在第一个视图中的位置
    self.vc.offsetY = stopY;
}

/*
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //每次移动完成之后需要将偏移量清零（如果不清零，偏移量是叠加的）
    [pan setTranslation:CGPointZero inView:self.view] ;
    
//    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^");
    //返回的是相对于self.view的偏移量
    CGPoint point = [pan translationInView:self.view] ;
//    NSLog(@"--- ponit.y = %f -----",point.y);
//    self.shadowView.transform = CGAffineTransformMakeTranslation(0, point.y) ;

    if (self.shadowView.frame.origin.y < 30) {
        self.shadowVieww.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;
    }else
    {
        self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, point.y) ;
    }
    
    
//    NSLog(@"----- y = %f ------", self.shadowView.frame.origin.y);
     //每次移动完成之后需要将偏移量清零（如果不清零，偏移量是叠加的）
    [pan setTranslation:CGPointZero inView:self.view] ;
    
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        float currentY = self.shadowView.frame.origin.y;
        
        float s1 = (Y2 - Y1)/2.0 + Y1;
        float s2 = (Y3 - Y2)/2.0 + Y2;
        
        float stopY = 0;
        
        if (currentY > 0 && currentY < s1 ) {
            
            // 停在y1的位置
            stopY = Y1;
            
        }else if (currentY >= s1 && currentY < s2)
        {
            // 停在y2的位置
            stopY = Y2;
        }else if (currentY >= s2 && currentY < self.view.frame.size.height)
        {
            // 停在y3的位置
            stopY = Y3;
        }
        else
        {
            stopY = 50;
        }
//        NSLog(@"     %f        ", stopY);
        [UIView animateWithDuration:0.4 animations:^{
            
            self.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
}
*/



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"-----------  ------------");
    // searchBar收起键盘
    UIButton *cancelBtn = [self.vc.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}





//                                                                                与手势同步地
/**
        返回值为NO  swipe不响应手势 table响应手势
        返回值为YES swipe、table也会响应手势, 但是把table的scrollEnabled为No就不会响应table了
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    NSLog(@"----------- table =  %f ------------",self.vc.table.contentOffset.y);
    // 触摸事件，一响应 就把searchBar的键盘收起来
    // searchBar收起键盘
    UIButton *cancelBtn = [self.vc.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.vc.table.scrollEnabled == YES && self.vc.table.contentOffset.y != 0) {
        return NO;
    }
    if (self.vc.table.scrollEnabled == YES) {
        return YES;
    }
    return NO;
}





#pragma mark - 懒加载
-(SecondViewController *)vc
{
    if (!_vc) {
        _vc = [[SecondViewController alloc] init];
    
        
        // -------------- 添加手势 轻扫手势  -----------
        self.swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        self.swipe1.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向
        //    [self.view addGestureRecognizer:swipe];
        
        self.swipe1.delegate = self;
        [_vc.table addGestureRecognizer:self.swipe1];

        UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipe2.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向
        //    [self.view addGestureRecognizer:swipe];
        swipe2.delegate = self;
        [_vc.table addGestureRecognizer:swipe2];
        
        
        
//        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//        pan.delegate = self;
//        [_vc.table addGestureRecognizer:self.pan];
        
        // 后面的这个手势要是识别成功的话就不会执行前一个手势了
//        [pan requireGestureRecognizerToFail:self.swipe1]; // 先识别swipe
    }
    return _vc;
}


-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, Y3, self.view.frame.size.width, self.view.frame.size.height);
//        _shadowView.backgroundColor = [UIColor clearColor];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowRadius = 10;
        _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
        _shadowView.layer.shadowOpacity = 0.8;                       //      不透明度
    }
    return _shadowView;
}




@end





















