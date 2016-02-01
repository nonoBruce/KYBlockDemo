//
//  HttpRequest.m
//  Block测试示例
//
//  Created by yanwen on 15/4/29.
//  Copyright (c) 2015年 GameBegin. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

+ (void)postRequestWithURL:(NSString *)urlStr
                 paramters:(NSString *)paramters
              finshedBlock:(ConnectionFinishBlock)block
{
    HttpRequest *httpRequest = [[HttpRequest alloc]init];
    httpRequest.finishBlock = block;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *requset = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [requset setHTTPBody:[paramters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:requset delegate:httpRequest];
    NSLog(connection ? @"连接创建成功" : @"连接创建失败");
}

/**
 *  接收到服务器回应的时回调
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (!self.resultData) {
        self.resultData = [[NSMutableData alloc]init];
    } else {
        [self.resultData setLength:0];
    }
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dic = [httpResponse allHeaderFields];
        NSLog(@"[network]allHeaderFields:%@",[dic description]);
    }
    
//    NSLog(@"%@",[NSThread currentThread]) ;
    
}

/**
 *  接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
 */


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSLog(@"didReceiveData = %@",[NSThread currentThread]) ;

    [self.resultData appendData:data];
    
}

/**
 *  数据传完之后调用此方法
 */

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *resultStr = [[NSString alloc]initWithData:self.resultData
                                               encoding:NSUTF8StringEncoding];
    if (self.finishBlock) {
        self.finishBlock(YES, resultStr);
    }
    
//    NSLog(@" --------- %@",[NSThread currentThread]);

}

/**
 *  网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"network error : %@", [error localizedDescription]);
    
    if (self.finishBlock) {
        self.finishBlock(NO, nil);
    }
}


@end
