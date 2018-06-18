//
//  RuntimeViewController.m
//  MyOCNote
//
//  Created by 秦威 on 2018/6/17.
//  Copyright © 2018年 秦威. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/message.h>
#import "Person.h"
#import "Person+Student.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self basic];
    
    [self using];
    
    
}

#pragma mark -- 基本概念
- (void) basic {
    /*
     *runtime消息机制：对于一个对象obj要执行它的对象方法method时，runtime的执行流程为:
     *1.通过obj的isa指针找到它的class
     *2.在class的method list中找到方法method
     *3.如果没有找到method，则继续在它的父类中寻找
     *一旦找到method，就去执行它的实现IMP
     */
    
    /*
     *每次查找到method后，objc_class的成员变量objc_cache就会将method缓存下来以提高之
     *后的查找效率，缓存时，objc_cache会将method的method_name作为key，method的
     *method_imp作为value,当再次收到method时就可以直接在objc_class的method_cache中
     *查找
     */
    
    /*
     *消息传递的机制：
     *系统会找到消息接受的对象，再通过它的isa指针找到它的class
     *找到class之后会查找它的method_list(对象方法（-方法）会保存到类对象的方法列表中，类方法（+方法）会保存到元类的方法列表中)，看看是否有selector方法（内部步骤为注册方法编号（SEL）然后根据方法编号查找对应的方法）
     *如果没有则继续查找它的父类
     *找到对应的method，执行它的IMP
     *如果有返回值则转发IMP的返回值
     */
    
    /*
     *isa指针
     *实例——》类——》元类——》NSObject元类——》自身
     *根据isa指针我们就能知道将来调用哪个类的方法
     */
    
    // 例如
    //    Person *p = [[Person alloc] init];
    
    // 转换成runtime方法
    Person *p = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
    p = objc_msgSend(p, sel_registerName("init"));
    // 调用对象方法(让类对象发送消息)
    objc_msgSend(p, @selector(eat));
    objc_msgSend(p, @selector(sleep:), 20);
    
    NSLog(@"%@", p.name);
}

#pragma mark -- 常用方法
- (void) using {
    /*
     *runtime常用方法：
     *动态控制属性
     *动态添加方法
     *给分类添加属性
     *动态交换方法实现
     *拦截并替换方法
     *字典与模型的自动转换
     *实现NSCoding的自动归档与解档
     */
    
    [self changeProperty];
    
    [self addMethod];
    
    
}

/**
    动态控制属性
 */
- (void) changeProperty {
    Person *p = [[Person alloc] init];
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([p class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = ivar[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        if ([name isEqualToString:@"_name"]) {
            object_setIvar(p, var, @"Garret");
            break;
        }
    }
    NSLog(@"%@", p.name);
    
    p.score = 90;
    NSLog(@"score = %ld", p.score);
}

// 动态添加方法
- (void) addMethod {
    Person *p = [[Person alloc] init];
    [p performSelector:@selector(run:) withObject:@"10"];
}


@end

@implementation UIImage (image)
#pragma mark -- 交换方法
+(void)load {
    /*
     *load方法只会在类加载进内存的时候调用一次，方法应该先交换，再调用
     */
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    Method myImageNamedMethod = class_getClassMethod(self, @selector(myImageNamed:));
    method_exchangeImplementations(imageNamedMethod, myImageNamedMethod);
}

+ (UIImage *)myImageNamed:(NSString *)name {
    /*
     *由于方法已经被交换，所以此处不会有死循环
     */
    UIImage *image = [UIImage myImageNamed:name];
    if (image) {
        NSLog(@"image load success");
    } else {
        NSLog(@"image load fail");
    }
    return image;
}

@end


