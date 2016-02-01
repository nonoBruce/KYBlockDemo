//
//  HttpRequest.h
//  Block测试示例
//
//  Created by yanwen on 15/4/29.
//  Copyright (c) 2015年 GameBegin. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个block类型
typedef void (^ConnectionFinishBlock)(BOOL isSuccess, NSString *dataString);//返回值类型  (^block名字) (参数类型)

@interface HttpRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSMutableData *resultData;


@property (nonatomic,copy) ConnectionFinishBlock finishBlock;

+ (void)postRequestWithURL:(NSString *)urlStr
                 paramters:(NSString *)paramters
              finshedBlock:(ConnectionFinishBlock)block;

@end
