//
//  Person.h
//  CMoeDataBase
//
//  Created by CMoe on 16/8/21.
//  Copyright © 2016年 CMoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

///姓名
@property (nonatomic, copy)   NSString              * name;
///年龄
@property (nonatomic, assign) NSInteger             age;
///身高
@property (nonatomic, assign) float                 height;

@end
