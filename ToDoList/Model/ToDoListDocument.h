//
//  ToDoListDocument.h
//  ToDoList
//
//  Created by Aleksey on 7/6/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoListDataBase.h"
#import "Task.h"

@interface ToDoListDocument : NSObject

@property (nonatomic, strong) Task *taskData;
@property (nonatomic, strong) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithTitle:(NSString *)title parentTask:(Task *)parentTask;
- (void)saveData;
- (void)deleteData;

@end
