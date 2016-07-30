//
//  NSObject+Runtime.m
//  NavigationController专场练习
//
//  Created by 孙亚东 on 16/7/29.
//  Copyright © 2016年 Sunyadong. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>


@implementation NSObject (Runtime)

+(instancetype)modelWithDict:(NSDictionary *)dic{


    id objc = [[self alloc]init];
    
    //获取属性目录
    NSArray * array = [self getIvarArray];
    
    //对字典进行遍历
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        
        //如果属性列表中有
        if ([array containsObject:key]) {
            
            //进行字典转模型
            [objc setValue:obj forKey:key];
            
        }
  
    }];

    return objc;

}


-(NSArray *)getIvarArray{
    
    
    //利用运行时获取属性列表
    NSArray *propertyList = objc_getAssociatedObject(self, _cmd);
    
    if (propertyList != nil) {
        
        return propertyList;
        
    }
    
    //创建可变数组
    NSMutableArray *temArr = [NSMutableArray array];
    
    //获取属性列表
    unsigned int count = 0;
    
    objc_property_t *plist  = class_copyPropertyList([self class], &count);
    
    
    for (int i = 0; i < count; i ++) {
        
        
        objc_property_t  t = plist[i];
        
        
        //获取名字
        const char * name = property_getName(t);
        

        NSString *name = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        [temArr addObject:name];
        
     
        
    }
    
    free(plist);
    
    //将属性关联对象
    objc_setAssociatedObject(self, _cmd, temArr.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    
    return temArr.copy;


}

@end
