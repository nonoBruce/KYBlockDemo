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
//    [self localVariable];
//    [self staticVariable];
    exampleA();
//    exampleB();
//    exampleC();
//    exampleE();
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


#pragma mark - 网上常见例子
////////////////////////////////////////////////////////////////
//例子1
void exampleA() {
    char a = 'A';
    ^{
        NSLog(@"%c",a);
    }();
}


////////////////////////////////////////////////////////////////
//例子2
void exampleB_addBlockToArray(NSMutableArray *array) {
    char b = 'B';
    [array addObject:^{
        NSLog(@"%c",b);
    } ];
}
//这个block在非ARC下，分配到stack上，出了scope就会释放

void exampleB() {
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    
    block();
}



////////////////////////////////////////////////////////////////
//例子3
void exampleC_addBlockToArray(NSMutableArray *array) {
    [array addObject:^{
        NSLog(@"C\n");
    }];
}
void exampleC() {
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray(array);
    
    void (^block)() = [array objectAtIndex:0];
    block();
    
}



////////////////////////////////////////////////////////////////
//例子4
//在非ARC情况下报错，提示 返回的是一个local StackBlock，返回后就会被销毁
//在ARC会默认copy

//typedef void (^dBlock)();
//dBlock exampleD_getBlock() {
//    char d = 'D';
//    return ^{
//        printf("%c\n", d);
//    };
//}
//void exampleD() {
//    exampleD_getBlock()();
//}

////////////////////////////////////////////////////////////////
//例子5

typedef void (^eBlock)();
eBlock exampleE_getBlock() {
    char e = 'E';
    void (^block)() = ^{
        printf("%c\n", e);
    };
    return block;
//    提示：Address of stack-allocted block declared on line 113 returned to caller;
//    这个表示出了作用域（scope）就会失效（自动释放）
//    return [[block copy] autorelease];
}
void exampleE() {
    eBlock block = exampleE_getBlock();
    block();
}

@end
