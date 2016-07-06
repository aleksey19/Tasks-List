//
//  ToDoListDataBase.m
//  ToDoList
//
//  Created by Aleksey on 7/6/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "ToDoListDataBase.h"

@implementation ToDoListDataBase

+ (NSString *)getPrivateDocsDir
{
    // works
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

+ (NSMutableArray *)loadTasksDocument
{
    NSString *documentsDirectory = [ToDoListDataBase getPrivateDocsDir];
    NSLog(@"Loading tasks from dir: %@", documentsDirectory);
    
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"task" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            ToDoListDocument *doc = [[ToDoListDocument alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    
    return retval;
}

+ (NSString *)nextTaskDocumentPath
{
    NSString *documentsDirectory = [ToDoListDataBase getPrivateDocsDir];
    
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    int maxNumber = 0;
    
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"task" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    NSString *availableName = [NSString stringWithFormat:@"%d.task", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
}

@end
