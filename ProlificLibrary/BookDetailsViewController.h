//
//  BookDetailsViewController.h
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookDetailsViewController : UIViewController

/**
 * The book to display.
 */
@property (nonatomic, strong) Book* book;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *publisherLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameDateLabel;

@end
