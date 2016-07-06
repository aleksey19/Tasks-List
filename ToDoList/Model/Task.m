//
//  Task.m
//  ToDoList
//
//  Created by Aleksey on 7/5/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "Task.h"

static NSString * idKey = @"taskId";
static NSString * titleKey = @"title";
static NSString * dateKey = @"date";
static NSString * completedKey = @"completed";
static NSString * parentTaskKey = @"parentTask";
static NSString * subtasksKey = @"subtasks";
static NSString * subtasksCountKey = @"subtasksCount";
static NSString * isAllSubtasksCompletedKey = @"allSubtasksCompleted";

@implementation Task

- (instancetype)initWithTitle:(NSString *)title parentTask:(Task *)parentTask
{
    if (self = [super init]) {
        _title = [title copy];
        _parentTask = [parentTask copy];
    }
    return self;
}

#pragma mark - NSCoding protocol

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.taskId = [aDecoder decodeIntegerForKey:idKey];
        self.title = [aDecoder decodeObjectForKey:titleKey];
        self.modifiedDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:dateKey];
        self.completed = [aDecoder decodeBoolForKey:completedKey];
        self.parentTask = [aDecoder decodeObjectOfClass:[Task class] forKey:parentTaskKey];
        self.subtasks = [aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:subtasksKey];
        self.subtasksCount = [aDecoder decodeIntegerForKey:subtasksCountKey];
        self.isAllSubtasksCompleted = [aDecoder decodeBoolForKey:isAllSubtasksCompletedKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_taskId forKey:idKey];
    [aCoder encodeObject:_title forKey:titleKey];
    [aCoder encodeObject:_modifiedDate forKey:dateKey];
    [aCoder encodeBool:_completed forKey:completedKey];
    [aCoder encodeObject:_parentTask forKey:parentTaskKey];
    [aCoder encodeObject:_subtasks forKey:subtasksKey];
    [aCoder encodeInteger:_subtasksCount forKey:subtasksCountKey];
    [aCoder encodeBool:_isAllSubtasksCompleted forKey:isAllSubtasksCompletedKey];
}

#pragma mark - NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setTaskId:self.taskId];
        [copy setTitle:self.title];
        [copy setModifiedDate:self.modifiedDate];
        [copy setCompleted:self.completed];
        [copy setParentTask:self.parentTask];
        [copy setSubtasks:[self.subtasks copyWithZone:zone]];
        [copy setSubtasksCount:self.subtasksCount];
        [copy setIsAllSubtasksCompleted:self.isAllSubtasksCompleted];
    }
    return copy;
}

#pragma mark - isEqual

- (BOOL)isEqual:(id)object{
    
    if (![object isMemberOfClass:[Task class]]) {
        return NO;
    } else {
        return YES;
    }
}

@end
