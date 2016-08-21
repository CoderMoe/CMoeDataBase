//
//  NSObject+CMoeSQLite.m
//  CMoeDB
//
//  Created by CMoe on 16/8/19.
//  Copyright © 2016年 CMoe. All rights reserved.
//

#import "NSObject+CMoeSQLite.h"
#import <objc/runtime.h>
#import <sqlite3.h>

static sqlite3 *db = nil;
@implementation NSObject (CMoeSQLite)

- (BOOL)openDB:(NSString *)fileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", fileName]];
    NSLog(@"%@", filePath);
   int result = sqlite3_open(filePath.UTF8String, &db);
    if (result != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"CMoeDataBaseError" reason:@"文件路径是否错误" userInfo:nil];
        return NO;
    }
    return YES;
}

- (BOOL)closeDB {
    int result = sqlite3_close(db);
    if (result != SQLITE_OK) {
        NSLog(@"数据库已关闭，不要重复关闭");
    }
    db = nil;
    return YES;
}

- (void)saveToSQLite:(NSString *)fileName {
    NSString *tableName = NSStringFromClass(self.class).lowercaseString;
    [self saveToSQLite:fileName withTableName:tableName];
}

- (void)saveToSQLite:(NSString *)fileName withTableName:(NSString *)tableName {
    [self openDB:fileName];
    NSMutableString *createSQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (tid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,", tableName];
    NSMutableString *insertSQL = [NSMutableString stringWithFormat:@"INSERT INTO %@ VALUES((SELECT MAX(tid) FROM %@) + 1, ", tableName, tableName];
    unsigned int ivarCount = 0;
    Ivar *vars = class_copyIvarList(object_getClass(self), &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        Ivar var = vars[i];
        NSString *varName = [[NSString stringWithUTF8String:ivar_getName(var)] substringFromIndex:1];
        NSString *varType = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        [createSQL appendFormat:@"%@ %@,", [varName lowercaseString], [self convertSQLTypeFromVarType:varType]];
        [insertSQL appendFormat:@"'%@', ", [self valueForKey:varName]];
    }
    createSQL = [createSQL substringToIndex:createSQL.length - 1].mutableCopy;
    insertSQL = [insertSQL substringToIndex:insertSQL.length - 2].mutableCopy;
    [createSQL appendString:@");"];
    [insertSQL appendString:@");"];
    
    int result = sqlite3_exec(db, createSQL.UTF8String, nil, nil, nil);
    if (result != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"CMoeDataBaseError" reason:@"数据库建表失败" userInfo:nil];
    }
    
    result = sqlite3_exec(db, insertSQL.UTF8String, nil, nil, nil);
    if (result != SQLITE_OK) {
        @throw [NSException exceptionWithName:@"CMoeDataBaseError" reason:@"插入数据失败" userInfo:nil];
    }
    [self closeDB];
}

- (NSArray *)getObjectsFromDataFile:(NSString *)fileName {
    
//    [self openDB: fileName];
//    NSMutableString *selectSQL = [NSMutableString stringWithFormat:@"SELECT "];
//    unsigned int ivarCount = 0;
//    Ivar *vars = class_copyIvarList(object_getClass(self), &ivarCount);
//    for (int i = 0; i < ivarCount; i++) {
//        Ivar var = vars[i];
//        NSString *varName = [[NSString stringWithUTF8String:ivar_getName(var)] substringFromIndex:1];
//        NSString *varType = [NSString stringWithFormat:@""];
//    }
    return nil;
}

- (NSString *)convertSQLTypeFromVarType:(NSString *)varType {
    
    NSString *type = nil;
    if (varType.length > 2) {
        type = [varType substringWithRange:NSMakeRange(2, varType.length - 3)];
    } else {
        type = varType;
    }
    
    if ([type isEqualToString:@"NSString"] | [type isEqualToString:@"*"]) {
        type = @"TEXT";
    } else if ([type isEqualToString:@"NSInteger"] | [type.lowercaseString isEqualToString:@"i"] | [type.lowercaseString isEqualToString:@"q"] | [type.lowercaseString isEqualToString:@"s"] | [type.lowercaseString isEqualToString:@"l"]) {
        type = @"INTEGER";
    } else if ([type isEqualToString:@"UIImage"]) {
        type = @"NONE";
    } else if ([type.lowercaseString isEqualToString:@"f"] | [type.lowercaseString isEqualToString:@"d"]) {
        type = @"REAL";
    } else if ([type isEqualToString:@"B"]) {
        type = @"BOOL";
    } else {
        type = @"NUMERIC";
    }
    return type;
}



@end
