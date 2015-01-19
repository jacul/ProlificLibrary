//
//  WaitingView.h
//  ProlificLibrary
//
//  Created by zxd on 15/1/19.
//
//

#import <UIKit/UIKit.h>

@interface WaitingView : UIView

/**
 * Show an indicator in the given view.
 * This method is dispatched in the CURRENT queue.
 */
+(void)showBlockIndicatorIn:(UIView*)view;

/**
 * Dismiss the indicator if already displayed.
 * This method is dispatched in the MAIN queue.
 */
+(void)dismissCurrentIndicator;
@end
