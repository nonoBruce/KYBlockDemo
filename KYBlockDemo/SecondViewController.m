//
//  SecondViewController.m
//  KYBlockDemo
//
//  Created by bruce on 16/1/29.
//  Copyright © 2016年 ky. All rights reserved.
//

#import "SecondViewController.h"
#import "HttpRequest.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)doSomeThing:(FinishBlock)block {
    self.block = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToIndex)];
    
    
    
    //
    [self localVariable];
//    [self staticVariable];

}
-(void) backToIndex{
    //将首页的导航条隐藏掉
//    self.navigationController.navigationBar.hidden = YES;
    //跳转到父视图
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)butonClicked:(id)sender {
    self.block(YES,@"butonClicked");

}

- (IBAction)callbackBlock:(UIButton *)btn {
    [HttpRequest postRequestWithURL:@"http://www.baidu.com"
                          paramters:@""
                       finshedBlock:^(BOOL isSuccess, NSString *dataString) {
                           NSLog(@"请求完成");
                       }];
}

#pragma mark - 局部变量
//local variable
- (void)localVariable {
    int tmp = 100;
    
    long (^sum)(int,int) = ^long (int a,int b){
        return a+b+tmp;
    };
    
    tmp = 0;
    
    NSLog(@"sum = %ld",sum(1,2));
    //这里输出的103，而不是3，因为块，会拷贝常量 tmp=100；
    //且在函数实现的时候就会copy，
}


#pragma mark - STATIC
- (void)staticVariable {
    static long tmp = 100;
    long (^sum)(long, long) = ^long (long a,long b) {
        tmp ++;
        return tmp+a+b;
    };
    
    tmp = 0;
    NSLog(@"sum = %ld",sum(1,2));
    //这里输出的4，不是103
    NSLog(@"tem = %ld",tmp);
    //这里输出的1，不是100了
}

@end
