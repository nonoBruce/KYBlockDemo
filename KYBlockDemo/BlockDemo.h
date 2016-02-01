//
//  BlockDemo.h
//  KYBlockDemo
//
//  Created by bruce on 16/1/30.
//  Copyright © 2016年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BlockDemo;

typedef void (^executeFinishedBlock)(void);

typedef void (^executeFinishedBlockParam)(BlockDemo *);


@interface BlockDemo : NSObject {
    executeFinishedBlock finishBlock;
    executeFinishedBlockParam finishblockparam;
}

@property(nonatomic, assign) NSInteger resultCode;

+ (BlockDemo *)blockDemo;

- (void)setExecuteFinished:(executeFinishedBlock)block;

- (void)setExecutefinishedParam:(executeFinishedBlockParam )block;

- (void)executeTests;


@end
