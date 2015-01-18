//
//  BookDetailsViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import "BookDetailsViewController.h"
#import "BookManager.h"

#define BOOK_NOTEXIST 400

@interface BookDetailsViewController ()<UIAlertViewDelegate>


@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [[BookManager instance] fetchBook:self.book.url onFinish:^(NSString *response, NSArray *result) {
        if ([response isEqualToString:CODE_SUCCESS] && result.count>0) {
            self.book = result[0];
            __weak BookDetailsViewController* weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakself) {
                    [weakself loadBookInfo];
                }
            });
        }else{
            //Show alert and go back to main screen
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Book doesn't exist!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alert.tag = BOOK_NOTEXIST;
            [alert show];
        }
    }];
}

-(void)loadBookInfo{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.author;
    self.publisherLabel.text = self.book.publisher;
    self.tagsLabel.text = self.book.categories;
    if (self.book.lastCheckedOut!=nil && self.book.lastCheckedOutBy!=nil) {
        self.nameDateLabel.text = [NSString stringWithFormat:@"%@ @ %@", self.book.lastCheckedOutBy, self.book.lastCheckedOut];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBookInfo:(id)sender {

    NSArray *itemsToShare = @[self.book.description];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)clickCheckout:(id)sender {
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag== BOOK_NOTEXIST) {
        //Quit this screen
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
