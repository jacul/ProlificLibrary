//
//  AddBookViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import "AddBookViewController.h"
#import "BookManager.h"
#import "Book.h"
#import "WaitingView.h"

#define ASK_SAVE 100

@interface AddBookViewController ()<UIAlertViewDelegate>

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)clickSubmit:(id)sender {
    [self.view endEditing:YES];
    if (self.bookTitleText.text.length==0 || self.bookAuthorText.text.length==0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Book title and/or author can't be empty" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    BookManager* manager = [BookManager instance];
    Book* book = [Book new];
    book.author = self.bookAuthorText.text;
    book.categories = self.bookCategoryText.text;
    book.title = self.bookTitleText.text;
    book.publisher = self.bookPublisherText.text;
    
    [WaitingView showBlockIndicatorIn:self.view];
    [manager addBook:book onFinish:^(NSString *response, NSArray *result) {
        [WaitingView dismissCurrentIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([CODE_SUCCESS isEqualToString:response]) {
                //Adding successfully
                //Notify the main screen
                [[NSNotificationCenter defaultCenter] postNotificationName:MSG_BOOKSNEEDUPDATE object:nil];
                //Close the view
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                //Adding book failed, alert the user
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Adding book to library failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        });

    }];
}

- (IBAction)finishAddBook:(id)sender {
    if (self.bookTitleText.text.length!=0 || self.bookAuthorText.text.length!=0 || self.bookCategoryText.text.length!=0 || self.bookPublisherText.text.length!=0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Unsaved book information" message:@"Are you sure to quit?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = ASK_SAVE;
        [alert show];
        return;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ASK_SAVE) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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
