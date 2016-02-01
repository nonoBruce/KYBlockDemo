//
//  SecondViewController.h
//  KYBlockDemo
//
//  Created by bruce on 16/1/29.
//  Copyright © 2016年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishBlock)(BOOL isSuccess, id result);

@interface SecondViewController : UIViewController

@property(nonatomic, copy)FinishBlock block;

- (void)doSomeThing:(FinishBlock)block;

@end
