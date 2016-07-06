//
//  TasksListTableViewController.m
//  ToDoList
//
//  Created by Aleksey on 7/5/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "TasksListTableViewController.h"
#import "SubtasksListTableViewController.h"

#import "ToDoListDataBase.h"
#import "ToDoListDocument.h"

#define TASK_COMPLETED_COLOR [UIColor colorWithRed:180/255.0 green:255/255.0 blue:177/255.0 alpha:1.0]
#define TASK_INCOMPLETED_COLOR [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:0.31]

@interface TasksListTableViewController ()
{
    NSInteger indexOfSelectedRow;
}

@property (nonatomic, strong) ToDoListDocument *toDoListDoc;
@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation TasksListTableViewController

- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"Add new task" message:@"Type task title and press add" preferredStyle:UIAlertControllerStyleAlert];
        [self setupAlertController];
    }
    return _alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadTasks];
}

- (void)setupView
{
    self.navigationController.topViewController.title = @"Tasks";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewTask:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)setupAlertController
{
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addNewTaskWithTitle:[self.alertController.textFields lastObject].text];
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

- (void)loadTasks
{
    self.dataSource = [ToDoListDataBase loadTasksDocument];
}

- (void)insertNewTask:(id)sender
{
    self.toDoListDoc = [[ToDoListDocument alloc] init];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)addNewTaskWithTitle:(NSString *)title
{
    if (!title.length) {
        title = @"No title";
    }
    
    self.toDoListDoc = [[ToDoListDocument alloc] initWithTitle:title parentTask:nil];
    self.toDoListDoc.taskData.modifiedDate = [NSDate date];
    self.toDoListDoc.taskData.completed = NO;
    self.toDoListDoc.taskData.subtasksCount = 0;
    self.toDoListDoc.taskData.subtasks = [NSMutableArray new];
    self.toDoListDoc.taskData.isAllSubtasksCompleted = NO;
    
    [self.toDoListDoc saveData];
    
    [self.dataSource addObject:self.toDoListDoc];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.toDoListDoc = nil;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    ToDoListDocument *doc = self.dataSource[indexPath.row];
    
    NSLocale* currentLocale = [NSLocale currentLocale];

    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.text = doc.taskData.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [doc.taskData.modifiedDate descriptionWithLocale:currentLocale]];
    doc.taskData.completed ? (cell.backgroundColor = TASK_COMPLETED_COLOR) : (cell.backgroundColor = TASK_INCOMPLETED_COLOR);
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoListDocument *taskDoc = [self.dataSource objectAtIndex:indexPath.row];
        
        [taskDoc deleteData];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfSelectedRow = indexPath.row;
    return indexPath;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailTaskSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = [segue destinationViewController];
            SubtasksListTableViewController *destVC = (SubtasksListTableViewController *)navVC.topViewController;
            destVC.taskDoc = self.dataSource[indexOfSelectedRow];
        }
    }
}

@end
