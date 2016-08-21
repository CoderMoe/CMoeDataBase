//
//  NSObject+CMoeSQLite.h
//  CMoeDB
//
//  Created by CMoe on 16/8/19.
//  Copyright © 2016年 CMoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CMoeSQLite)

///提示信息
//@property (nonatomic, copy)   NSString              * alertMessage;

///将对象存放到数据库
- (void)saveToSQLite:(NSString * _Nullable)fileName;
///从数据库中获取对象数组
- (NSArray *_Nullable)getObjectsFromDataFile:(NSString * _Nullable)fileName;

@end
