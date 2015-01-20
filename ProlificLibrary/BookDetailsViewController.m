//
//  BookDetailsViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import "BookDetailsViewController.h"
#import "BookManager.h"
#import "WaitingView.h"
#import "EditBookViewController.h"

#define BOOK_NOTEXIST 400
#define BOOK_CHECKOUT 200

@interface BookDetailsViewController ()<UIAlertViewDelegate>


@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Listener for book change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenerForBookChange:) name:MSG_BOOKSNEEDUPDATE object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    __weak BookDetailsViewController* weakself = self;
    [WaitingView showBlockIndicatorIn:self.view];
    [[BookManager instance] fetchBook:self.book.url onFinish:^(NSString *response, NSArray *result) {
        [WaitingView dismissCurrentIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([response isEqualToString:CODE_SUCCESS] && result.count>0) {
                
                self.book = result[0];
                if (weakself) {
                    [weakself loadBookInfo];
                }
            }else{
                //Show alert and go back to main screen
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Book doesn't exist!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alert.tag = BOOK_NOTEXIST;
                [alert show];
            }
        });
    }];
}

-(void)loadBookInfo{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.author;
    self.publisherLabel.text = self.book.publisher;
    self.tagsLabel.text = self.book.categories;
    if (self.book.lastCheckedOut!=nil && self.book.lastCheckedOutBy!=nil) {
        self.nameDateLabel.text = [NSString stringWithFormat:@"%@ @ %@", self.book.lastCheckedOutBy, self.book.lastCheckedOut];
    }else{
        self.nameDateLabel.text = nil;
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
    UIAlertView* askName = [[UIAlertView alloc]initWithTitle:@"Enter your name:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    askName.alertViewStyle = UIAlertViewStylePlainTextInput;
    askName.tag = BOOK_CHECKOUT;
    [askName show];
}

- (IBAction)clickEdit:(id)sender {
    [self performSegueWithIdentifier:@"edit" sender:self];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag== BOOK_NOTEXIST) {
        //Quit this screen
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(alertView.tag == BOOK_CHECKOUT){
        if (buttonIndex ==  alertView.firstOtherButtonIndex) {
            NSString* name = [alertView textFieldAtIndex:0].text;
            if (name.length==0) {
                //Didn't enter anything
                name = @"Anonymous";
            }
            
            Book* newBook = [Book new];
            newBook.lastCheckedOutBy = name;
            NSDateFormatter* formatter = [NSDateFormatter new];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
            newBook.lastCheckedOut = [formatter stringFromDate:[NSDate date]];
            
            [WaitingView showBlockIndicatorIn:self.view];
            __weak BookDetailsViewController* weakself = self;
            [[BookManager instance] updateBook:self.book withNewBook:newBook onFinish:^(NSString *response, NSMutableArray *result) {
                [WaitingView dismissCurrentIndicator];
                
                if ([response isEqualToString:CODE_SUCCESS] && result.count>0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakself) {
                            weakself.book = result[0];
                            [weakself loadBookInfo];
                        }
                    });
                }
            }];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"edit"]) {
        [(EditBookViewController*)segue.destinationViewController setBook:self.book];
    }
    
}

-(void)listenerForBookChange:(NSNotification*)notification{
    if ([notification.object isKindOfClass:[Book class]]) {
        self.book = (Book*)notification.object;
        [self loadBookInfo];
    }
}

@end
