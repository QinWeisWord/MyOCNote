//
//  Person+Student.m
//  MyOCNote
//
//  Created by 秦威 on 2018/6/18.
//  Copyright © 2018年 秦威. All rights reserved.
//

#import "Person+Student.h"
#import <objc/message.h>

@implementation Person (Student)

- (void)setScore:(NSInteger)score {
    objc_setAssociatedObject(self, @"score", @(score), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)score {
    return [objc_getAssociatedObject(self, @"score") integerValue];
}

@end
