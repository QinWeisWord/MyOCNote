//
//  Person.m
//  MyOCNote
//
//  Created by 秦威 on 2018/6/17.
//  Copyright © 2018年 秦威. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

- (void)eat {
    NSLog(@"eat");
}

- (void)sleep:(NSInteger)time {
    NSLog(@"sleep %ld", time);
}

#pragma mark -- 动态添加方法
void run(id self, SEL _cmd, NSString *meter) {
    NSLog(@"run %@ meter", meter);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"run:")) {
        // v@:@
        //v表示返回值void， @表示id， ：表示SEL， @表示传入参数meter
        class_addMethod(self, sel, (IMP)run, "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark -- 自动归档解档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = ivar[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(ivar);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList([Person class], &count);
        for (int i = 0; i < count; i++) {
            Ivar var = ivar[i];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
        free(ivar);
    }
    return self;
}

@end
