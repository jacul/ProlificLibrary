//
//  Book.h
//  ProlificLibrary
//
//  Created by zxd on 15/1/15.
//
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* categories;
@property (nonatomic, strong) NSString* lastCheckedOut;
@property (nonatomic, strong) NSString* lastCheckedOutBy;
@property (nonatomic, strong) NSString* publisher;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;

/**
 * Setup the book info with given dictionary.
 */
-(void)setBookInfoWithDict:(NSDictionary*)dict;
@end
