//
//  ActivityType.m
//  BoatDay
//
//  Created by Diogo Nunes on 24/06/14.
//  Copyright (c) 2014 Rocksauce Studios LLC. All rights reserved.
//

#import "ActivityType.h"

@implementation ActivityType

@dynamic name;
@dynamic order;

+ (NSString *)parseClassName {
    
    return @"ActivityType";
}

@end
