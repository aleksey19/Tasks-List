//
//  SubtasksListTableViewController.h
//  ToDoList
//
//  Created by Aleksey on 7/6/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "TableViewController.h"
#import "ToDoListDocument.h"

@interface SubtasksListTableViewController : TableViewController

@property (nonatomic, strong) ToDoListDocument *taskDoc;

@end
