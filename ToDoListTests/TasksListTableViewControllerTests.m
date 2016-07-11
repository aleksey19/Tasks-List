//
//  TasksListTableViewControllerTests.m
//  ToDoList
//
//  Created by Aleksey on 7/11/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "TasksListTableViewControllerTests.h"

@implementation TasksListTableViewControllerTests

- (void)setUp
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self.tasksListTVC = [storyboard instantiateViewControllerWithIdentifier:@"tasksTVC"];
}

@end
