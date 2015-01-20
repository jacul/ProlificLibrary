//
//  RootViewController.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/19.
//
//

#import "RootViewController.h"

#define MENU_OPEN @"open"
#define MENU_HIDE @"hide"

@interface RootViewController ()

@end

@implementation RootViewController

-(void)awakeFromNib{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentviewcontroller"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightsidemenu"];

    //Listener for menu open/hide
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventListener:) name:MENU_OPEN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventListener:) name:MENU_HIDE object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)showSideMenu{
    [[NSNotificationCenter defaultCenter] postNotificationName:MENU_OPEN object:nil];
}

+(void)hideSideMenu{
    [[NSNotificationCenter defaultCenter] postNotificationName:MENU_HIDE object:nil];
}

-(void)eventListener:(NSNotification*)notification{
    if ([notification.name isEqualToString:MENU_OPEN]) {
        [self presentRightMenuViewController];
    }else if([notification.name isEqualToString:MENU_HIDE]){
        [self hideMenuViewController];
    }
}
@end
