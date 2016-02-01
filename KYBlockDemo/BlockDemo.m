//
//  BlockDemo.m
//  KYBlockDemo
//
//  Created by bruce on 16/1/30.
//  Copyright © 2016年 ky. All rights reserved.
//

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define OBJC_ARC_ENABLED 1
#endif // __has_feature(objc_arc)

#if OBJC_ARC_ENABLED
#define OBJC_RETAIN(object)         (object)
#define OBJC_COPY(object)           (object)
#define OBJC_RELEASE(object)        object = nil
#define OBJC_AUTORELEASE(object)    (object)
#else
#define OBJC_RETAIN(object)           [object retain]
#define OBJC_COPY(object)             [object copy]
#define OBJC_RELEASE(object)          [object release], object = nil
#define OBJC_AUTORELEASE(object)      [object autorelease]
#endif


#import "BlockDemo.h"

@implementation BlockDemo

+ (BlockDemo *)blockDemo {
    return OBJC_AUTORELEASE([[BlockDemo alloc] init]);
}

- (id)init {
    if(self = [super init]) {
        NSLog(@"Object Constructor!");
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"Object Destoryed!");
    
#if !__has_feature(objc_arc)
    
    [super dealloc];
#endif
}


- (void)setExecuteFinished:(executeFinishedBlock)block {
    OBJC_RELEASE(finishBlock);
    
    finishBlock = OBJC_COPY(block);
}

- (void)setExecutefinishedParam:(executeFinishedBlockParam)block {
    OBJC_RELEASE(finishblockparam);
    finishblockparam = OBJC_COPY(block);
    
}

- (void)executeTests {
    [self performSelector:@selector(executeCallBack) withObject:nil afterDelay:3];
}

- (void)executeCallBack {
    _resultCode = 200;
    if(finishBlock) {
        finishBlock();
    }
    
    if(finishblockparam) {
        finishblockparam(self);
    }
}
@end
