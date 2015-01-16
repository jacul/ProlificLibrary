//
//  ViewController.h
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import <UIKit/UIKit.h>

@interface BookListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

