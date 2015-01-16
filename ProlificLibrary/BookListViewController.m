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

@interface BookListViewController (){
    NSArray* bookArray;
}

@end

@implementation BookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak UITableView* weaktable = self.tableView;
    [[BookManager instance] listBooks:^(NSString *response, NSArray *result) {
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"book"];
    Book* book = bookArray[indexPath.row];
    cell.booktitleLabel.text = book.title;
    cell.bookauthorLabel.text = book.author;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bookArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
@end