//
//  Book.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/15.
//
//

#import "Book.h"

@implementation Book

-(NSString*)description{
    
    return [NSString stringWithFormat:@"Title: %@\nAuthor: %@\nCategories: %@\nPublisher:%@",self.title, self.author, self.categories, self.publisher];
}

-(void)setBookInfoWithDict:(NSDictionary *)dict{
    self.author             = dict[@"author"];
    self.categories         = dict[@"categories"];
    self.lastCheckedOut     = dict[@"lastCheckedOut"];
    self.lastCheckedOutBy   = dict[@"lastCheckedOutBy"];
    self.publisher          = [dict[@"publisher"] description];
    self.title              = dict[@"title"];
    self.url                = [dict[@"url"] description];
}
@end
