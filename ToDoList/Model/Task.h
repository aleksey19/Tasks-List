//
//  Task.h
//  ToDoList
//
//  Created by Aleksey on 7/5/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject <NSCoding, NSCopying>

@property (nonatomic) NSInteger taskId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *modifiedDate;
@property (nonatomic) BOOL completed;
@property (nonatomic, strong) Task *parentTask;
@property (nonatomic, strong) NSMutableArray *subtasks;
@property (nonatomic) NSInteger subtasksCount;
@property (nonatomic) BOOL isAllSubtasksCompleted;

- (instancetype)initWithTitle:(NSString *)title parentTask:(Task *)parentTask;

@end
