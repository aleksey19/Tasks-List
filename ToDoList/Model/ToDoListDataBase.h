//
//  ToDoListDataBase.h
//  ToDoList
//
//  Created by Aleksey on 7/6/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoListDocument.h"

@interface ToDoListDataBase : NSObject

+ (NSMutableArray *)loadTasksDocument;
+ (NSString *)nextTaskDocumentPath;

@end
