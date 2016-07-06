//
//  ToDoListDocument.m
//  ToDoList
//
//  Created by Aleksey on 7/6/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "ToDoListDocument.h"

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation ToDoListDocument

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithDocPath:(NSString *)docPath
{
    if (self = [super init])
    {
        _docPath = docPath.copy;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title parentTask:(Task *)parentTask
{
    if (self = [super init]) {
        _taskData = [[Task alloc] initWithTitle:title parentTask:parentTask];
    }
    
    return self;
}

- (Task *)taskData
{
    if (_taskData) return _taskData;
    
    NSString *dataPath = [self.docPath stringByAppendingString:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (!codedData) return nil;
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _taskData = [unArchiver decodeObjectForKey:kDataKey];
    [unArchiver finishDecoding];
    
    return _taskData;
}

- (BOOL)createDataPath
{
    if (_docPath == nil) {
        _docPath = [ToDoListDataBase nextTaskDocumentPath];
    }
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:self.docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path, %@", error.localizedDescription);
    }
    return success;
}

- (void)saveData
{
    if (_taskData == nil) return;
    
    [self createDataPath];
    NSString *dataPath = [self.docPath stringByAppendingString:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.taskData forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

- (void)deleteData
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.docPath error:&error];
    if (!success) {
        NSLog(@"Failed to delete document, %@", error.localizedDescription);
    }
}

@end
