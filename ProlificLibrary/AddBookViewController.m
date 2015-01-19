//
//  AddBookViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import "AddBookViewController.h"
#import "BookManager.h"

@interface AddBookViewController ()

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

- (IBAction)clickSubmit:(id)sender {
    if (self.bookTitleText.text.length==0 || self.bookAuthorText.text.length==0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Book title and/or author can't be empty" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    BookManager* manager = [BookManager instance];
    [manager addBookWithAuthor:self.bookAuthorText.text Tags:self.bookCategoryText.text Title:self.bookTitleText.text Publisher:self.bookPublisherText.text LastCheckout:@"" onFinish:^(NSString *response, NSArray *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([CODE_SUCCESS isEqualToString:response]) {
                //Adding successfully                
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
