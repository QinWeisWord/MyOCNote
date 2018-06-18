//
//  Person.h
//  MyOCNote
//
//  Created by 秦威 on 2018/6/17.
//  Copyright © 2018年 秦威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name;

-(void)eat;

-(void)sleep:(NSInteger)time;

@end
