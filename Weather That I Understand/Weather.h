//
//  Weather.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-26.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Weather : NSObject
@property(assign, nonatomic) double chigh;
@property(assign, nonatomic) double fhigh;

@property(assign, nonatomic) double clow;
@property(assign, nonatomic) double flow;

@property(assign, nonatomic) double cfeelLike;
@property(assign, nonatomic) double ffeelslike;

@property(retain, nonatomic) NSString* wc;

@property(assign, nonatomic) double cwind;
@property(assign, nonatomic) double fwind;
+(NSString*)getDefaultMessageString;

@end
