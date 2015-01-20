//
//  EditBookViewController.h
//  ProlificLibrary
//
//  Created by zxd on 15/1/19.
//
//

#import <UIKit/UIKit.h>
@class Book;

@interface EditBookViewController : UIViewController

@property (nonatomic, strong) Book* book;

@property (strong, nonatomic) IBOutlet UITextField *bookTitleText;
@property (strong, nonatomic) IBOutlet UITextField *bookAuthorText;
@property (strong, nonatomic) IBOutlet UITextField *bookPublisherText;
@property (strong, nonatomic) IBOutlet UITextField *bookCategoryText;


@end
