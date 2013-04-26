//
//  WeatherServiceDelegate.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-24.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherServiceDelegate : NSObject <NSURLConnectionDelegate>{
    NSMutableData* receivedData;
    NSURLRequest* _request;
    void(^_callback)(NSMutableData*);
}
-(id)initWithRequest:(NSURLRequest*)request;
-(void)startConnection:(void(^)(NSMutableData*))callback;
@end
