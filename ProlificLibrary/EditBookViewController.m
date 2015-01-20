//
//  EditBookViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/19.
//
//

#import "EditBookViewController.h"
#import "Book.h"
#import "BookManager.h"
#import "WaitingView.h"

#define ASK_SAVE 100

@interface EditBookViewController ()<UIAlertViewDelegate>

@end

@implementation EditBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.book) {
        self.bookTitleText.text = self.book.title;
        self.bookAuthorText.text = self.book.author;
        self.bookPublisherText.text = self.book.publisher;
        self.bookCategoryText.text = self.book.categories;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDone:(id)sender {
    if (![self.bookTitleText.text isEqualToString:self.book.title]   ||
        ![self.bookAuthorText.text isEqualToString:self.book.author] ||
        ![self.bookCategoryText.text isEqualToString:self.book.categories] ||
        ![self.bookPublisherText.text isEqualToString:self.book.publisher] ) {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Book info changed" message:@"Discard changes?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = ASK_SAVE;
        [alert show];
        
        return;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)clickSubmit:(id)sender {
    [self.view endEditing:YES];
    
    //Save book info
    self.book.title = self.bookTitleText.text;
    self.book.author = self.bookAuthorText.text;
    self.book.publisher = self.bookPublisherText.text;
    self.book.categories = self.bookCategoryText.text;
    
    [WaitingView showBlockIndicatorIn:self.view];
    [[BookManager instance] updateBook:self.book withNewBook:self.book onFinish:^(NSString *response, NSMutableArray *result) {
        [WaitingView dismissCurrentIndicator];
        
        if ([response isEqualToString:CODE_SUCCESS]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Notify the book info screen to update
                [[NSNotificationCenter defaultCenter] postNotificationName:MSG_BOOKSNEEDUPDATE object:self.book];
                //Close this view
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ASK_SAVE) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
