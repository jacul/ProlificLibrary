//
//  SideMenuViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/19.
//
//

#import "SideMenuViewController.h"
#import "BookManager.h"
#import "WaitingView.h"
#import "RootViewController.h"

#define DELETE_ALERT 100
#define DELETE_DONE  200

@interface SideMenuViewController ()<UIAlertViewDelegate>{
    NSArray* menuarray;
}

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuarray = @[@"Clean all", @"About"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return menuarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu" forIndexPath:indexPath];
    
    cell.textLabel.text = menuarray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self cleanAllBooks];
            break;
        case 1:
            
            [self showAbout];
            break;
        default:
            break;
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

//Ask to clean books
-(void)cleanAllBooks{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Enter DELETE to clean the library" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = DELETE_ALERT;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

/**
 * Actually do the cleaning.
 */
-(void)doCleanBooks{
    [WaitingView showBlockIndicatorIn:self.view];
    //Perform deletion
    [[BookManager instance] deleteAll:^(NSString *response, NSMutableArray *result) {
        [WaitingView dismissCurrentIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([response isEqualToString:CODE_SUCCESS]) {
                //Delete successfully
                UIAlertView* donealert = [[UIAlertView alloc]initWithTitle:@"Delete all books successfully" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                donealert.tag = DELETE_DONE;
                //After dismissing this alert, also close the side menu
                [donealert show];
                
            }else{
                //Delete failed
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Delete failed" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];

                //After dismissing this alert, also close the side menu
                [alert show];
            }
            
        });
        
    }];
}

-(void)showAbout{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Prolific Library" message:@"copy is right 2015" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == DELETE_ALERT) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSString* enter = [[alertView textFieldAtIndex:0] text];
            //check input
            if ([enter isEqualToString:@"DELETE"]) {
                [self doCleanBooks];
                return;
            }
        }
        //Something stopped deletion
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"No book deleted." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    }else if( alertView.tag == DELETE_DONE){
        //Tell the main menu to refresh
        [[NSNotificationCenter defaultCenter] postNotificationName:MSG_BOOKSNEEDUPDATE object:nil];
        //close the menu
        [RootViewController hideSideMenu];
    }
}
@end
