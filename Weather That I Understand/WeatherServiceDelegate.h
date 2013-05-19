//
//  WeatherServiceDelegate.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-24.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherServiceDelegate : NSObject <NSURLConnectionDelegate>{
    long fileSize;
    NSMutableData* receivedData;
    NSURLRequest* _request;
    void(^_callback)(NSMutableData*);
    void(^_progressCallback)(float);
}
-(id)initWithRequest:(NSURLRequest*)request;
-(void)startConnection:(void(^)(NSMutableData*))callback progress:(void(^)(float))progressCallback;
@end
