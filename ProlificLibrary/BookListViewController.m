//
//  ViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import "BookListViewController.h"
#import "BookInfoTableViewCell.h"
#import "BookManager.h"
#import "Book.h"
#import "BookDetailsViewController.h"
#import "WaitingView.h"
#import "RootViewController.h"

@interface BookListViewController (){
    NSMutableArray* bookArray;

}

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self updateLibrary];
    
    //Add listener for book changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLibraryListener:) name:MSG_BOOKSNEEDUPDATE object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateLibrary{

    [WaitingView showBlockIndicatorIn:self.view];
    
    __weak UITableView* weaktable = self.tableView;
    [[BookManager instance] listBooks:^(NSString *response, NSMutableArray *result) {
        
        [WaitingView dismissCurrentIndicator];
        
        if ([response isEqualToString:CODE_SUCCESS]) {
            bookArray = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weaktable) {
                    [weaktable reloadData];
                }
            });
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Open the side menu
- (IBAction)openMenu:(id)sender {
    [RootViewController showSideMenu];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"book"];
    Book* book = bookArray[indexPath.row];
    cell.booktitleLabel.text = book.title;
    cell.bookauthorLabel.text = book.author;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [self performSegueWithIdentifier:@"detail" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [WaitingView showBlockIndicatorIn:self.view];
        
        [[BookManager instance] deleteBook:[(Book*)bookArray[indexPath.row] url] onFinish:^(NSString *response, NSMutableArray *result) {
            
            [WaitingView dismissCurrentIndicator];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([response isEqualToString:CODE_SUCCESS]) {
                    
                    [bookArray removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            });
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bookArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        BookDetailsViewController* vc = segue.destinationViewController;
        vc.book = [bookArray objectAtIndex: [(NSIndexPath*)sender row]];
    }
}

#pragma mark Listener for book update
-(void)updateLibraryListener:(NSNotification*)notification{
    [self updateLibrary];
}
@end
