//
//  JMGCountedSetAdditions.m
//  CompareStrings
//
//  Created by Jeff on 2/25/13.
//  Copyright (c) 2013 codeSlider. All rights reserved.
//

#import "JMGCountedSetAdditions.h"

@implementation NSCountedSet (JMGCountedSetAdditions)


- (NSArray *) objectsWithCount:(NSUInteger) count {
    NSMutableArray *array = [NSMutableArray array];
    for(id obj in self) {
        if([self countForObject:obj] == count) {
            [array addObject:obj];
        }
    }
    return [array copy];
}

@end

