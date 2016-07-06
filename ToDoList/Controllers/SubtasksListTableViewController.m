//
//  SubtasksListTableViewController.m
//  ToDoList
//
//  Created by Aleksey on 7/6/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "SubtasksListTableViewController.h"

@interface SubtasksListTableViewController ()

@property (nonatomic, strong) ToDoListDocument *subtaskDoc;
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation SubtasksListTableViewController

- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"Add new subtask" message:@"Type subtask title and press add" preferredStyle:UIAlertControllerStyleAlert];
        [self setupAlertController];
    }
    return _alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self getSubtasks];
}

- (void)getSubtasks
{
    self.dataSource = self.taskDoc.taskData.subtasks;
}

- (void)setupView
{
    self.navigationController.topViewController.title = self.taskDoc.taskData.title;
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionDialog)];
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, actionButton];
}

- (void)showActionDialog
{
    UIAlertController *actionDialog = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *deleteAllSubtasksAction = [UIAlertAction actionWithTitle:@"Delate all subtasks" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAllSubtasks];
    }];
    [actionDialog addAction:deleteAllSubtasksAction];
    
    UIAlertAction *completeAllSubtasksAction = [UIAlertAction actionWithTitle:@"Complete all subtasks" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self completeAllSubtasks];
    }];
    [actionDialog addAction:completeAllSubtasksAction];
    
    UIAlertAction *addSubtaskAction = [UIAlertAction actionWithTitle:@"Add subtask" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertNewSubTask:nil];
    }];
    [actionDialog addAction:addSubtaskAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [actionDialog dismissViewControllerAnimated:YES completion:nil];
    }];
    [actionDialog addAction:cancelAction];
    
    [self presentViewController:actionDialog animated:YES completion:nil];
}

- (void)deleteAllSubtasks
{
    [self.taskDoc.taskData.subtasks removeAllObjects];
    [self.taskDoc saveData];
    [self.tableView reloadData];
}

- (void)completeAllSubtasks
{
    for (Task *task in self.taskDoc.taskData.subtasks) {
        task.completed = YES;
    }
    [self.taskDoc saveData];
    [self refershTask];
    [self.tableView reloadData];
}

- (void)setupAlertController
{
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addNewSubTaskWithTitle:[self.alertController.textFields lastObject].text];
        [self.alertController.textFields lastObject].text = @"";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertController addAction:addAction];
    [self.alertController addAction:cancelAction];
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter task title";
    }];
}

- (void)addNewSubTaskWithTitle:(NSString *)title
{
    if (!title.length) {
        title = @"No title";
    }
    
    self.subtaskDoc = [[ToDoListDocument alloc] initWithTitle:title parentTask:self.taskDoc.taskData];
    self.subtaskDoc.taskData.modifiedDate = [NSDate date];
    self.taskDoc.taskData.modifiedDate = self.subtaskDoc.taskData.modifiedDate;
    self.subtaskDoc.taskData.completed = NO;
    [self.taskDoc.taskData.subtasks addObject:self.subtaskDoc.taskData];
    
    [self.taskDoc saveData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.subtaskDoc = nil;
}

- (void)refershTask
{
    NSInteger countOfUncompletedTasks = self.taskDoc.taskData.subtasks.count;
    self.taskDoc.taskData.subtasksCount = self.taskDoc.taskData.subtasks.count;
    for (Task *task in self.taskDoc.taskData.subtasks) {
        if (task.completed == NO) break;
        else countOfUncompletedTasks--;
    }
    if (countOfUncompletedTasks == 0) {
        self.taskDoc.taskData.completed = self.taskDoc.taskData.isAllSubtasksCompleted = YES;
    } else { self.taskDoc.taskData.completed = self.taskDoc.taskData.isAllSubtasksCompleted = NO; }
    [self.taskDoc saveData];
}

- (void)insertNewSubTask:(id)sender
{
    [self presentViewController:self.alertController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    Task *subtask = self.dataSource[indexPath.row];
    
    NSLocale* currentLocale = [NSLocale currentLocale];
    
    cell.textLabel.text = subtask.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [subtask.modifiedDate descriptionWithLocale:currentLocale]];
    subtask.completed ? (cell.accessoryType = UITableViewCellAccessoryCheckmark) : (cell.accessoryType = UITableViewCellAccessoryNone);
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskDoc.taskData.subtasks removeObjectAtIndex:indexPath.row];
        [self.taskDoc saveData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    Task *subtask = self.dataSource[indexPath.row];
    subtask.completed = !subtask.completed;
    subtask.modifiedDate = [NSDate date];
    subtask.completed ? (cell.accessoryType = UITableViewCellAccessoryCheckmark) : (cell.accessoryType = UITableViewCellAccessoryNone);
    [self.taskDoc saveData];
//    [self.taskDoc.taskData.subtasks replaceObjectAtIndex:indexPath.row withObject:subtask];
    [self refershTask];
}

@end
