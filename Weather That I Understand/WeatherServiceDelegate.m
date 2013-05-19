//
//  WeatherServiceDelegate.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-24.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "WeatherServiceDelegate.h"

@implementation WeatherServiceDelegate
-(id)initWithRequest:(NSURLRequest *)request{
    if (self = [super init]){
        _request = request;
    }
    return self;
    
}

-(void)startConnection:(void (^)(NSMutableData*))callback progress:(void (^)(float))progressCallback{
    // create the connection with the request
    // and start loading the data
    NSURLConnection *yesterdayWeatherConnection=[[NSURLConnection alloc] initWithRequest:_request delegate:self];
    if (yesterdayWeatherConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data] ;
        _callback = callback;
        _progressCallback = progressCallback;
    } else {
        // Inform the user that the connection failed.
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
    fileSize = [response expectedContentLength];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[receivedData length]];
    _progressCallback([resourceLength floatValue] / fileSize);
    NSLog(@"progress is %.00f / %ld \n", [resourceLength floatValue], fileSize);
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    _callback(receivedData);
}


@end
