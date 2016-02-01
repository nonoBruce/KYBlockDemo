//
//  ViewController.m
//  KYBlockDemo
//
//  Created by bruce on 16/1/29.
//  Copyright © 2016年 ky. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"


#import "BlockDemo.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self block];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)block{
    //中括号，作用域
    //    NSGlobalBlock
    {
        float (^sum)(float,float) = ^(float a,float b){
            return (a+b);
        };
        
        NSLog(@"%f",sum(10,20)) ;
    }
    
    
    //    NSStackBlock
    
    {
        NSArray *arr = @[@"1",@"2"];
        void (^TestBlock)(void) = ^{
            NSLog(@"arr = %@",arr);
        };
        
        NSLog(@"block is %@",^{
            NSLog(@"arr:%@",arr);
        });
        
        
        NSLog(@"block is %@",TestBlock);
        //这个在非arc打印的是：__NSStackBlock__
        //arc打印的是：__NSMallocBlock__
    }
    
}



#pragma mark - 页面上的按钮
- (IBAction)push:(UIButton *)button {
    SecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    [secondViewController doSomeThing:^(BOOL isSuccess, id result) {
        NSLog(@"block callback = %@",result);
    }];
    [self.navigationController pushViewController:secondViewController animated:YES];
}

//正常之一
- (IBAction)testBlock:(id)sender {
    BlockDemo *demo = [[BlockDemo alloc] init];
    __weak BlockDemo *weakDemo = demo;

    [demo setExecuteFinished:^{
        if(weakDemo.resultCode == 200) {
            NSLog(@"call back ok.");
        }
    }];
    
    [demo executeTests];
}

//不会发出警告，但是demo没有释放，会造成内存泄露
- (IBAction)test1Block:(UIButton *)btn {
    __block BlockDemo *demo = [[BlockDemo alloc] init];
    
    [demo setExecuteFinished:^{
        if(demo.resultCode == 200) {
            NSLog(@"call back ok.111111111111");
        }
    }];
    
    [demo executeTests];
}

- (IBAction)test2Block:(UIButton *)btn {
    BlockDemo *demo = [[BlockDemo alloc] init];
    [demo setExecuteFinished:^{
        if(demo.resultCode == 200) {
            NSLog(@"call back ok.222222222222");
        }
    }];
    
    [demo executeTests];
}

//一创建就会释放，且有提示信息
- (IBAction)block3Block:(UIButton *)btn {
    __weak BlockDemo *demo = [[BlockDemo alloc] init];
    [demo setExecuteFinished:^{
        if(demo.resultCode == 200) {
            NSLog(@"call back ok.333333333333");
        }
    }];
    
    [demo executeTests];
}

//不会提示，但是还是会  创建后，直接释放了
- (IBAction)block4Block:(UIButton *)btn {
    __weak BlockDemo *demo = [BlockDemo blockDemo];
    [demo setExecuteFinished:^{
        if(demo.resultCode == 200) {
            NSLog(@"call back ok.444444444444");
        }
    }];
    
    [demo executeTests];
}

//正常之二
//block回调，把自身作为参数传到block里面，这样block会给我们的参数弱引用，
//不用添加__weak，也不会产出循环引用
//
- (IBAction)block5Block:(UIButton *)btn {
//    BlockDemo *demo = [BlockDemo blockDemo];
    BlockDemo *demo = [[BlockDemo alloc] init];

    [demo setExecutefinishedParam:^(BlockDemo *blockDemo) {
        if(blockDemo.resultCode == 200) {
            NSLog(@"call back ok.5555555555");
        }
        
    }];
    
    [demo executeTests];
}

@end
