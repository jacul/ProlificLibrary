//
//  Book.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/15.
//
//

#import "Book.h"
#define nilOrJSONObjectForKey(JSON_, KEY_) [[JSON_ objectForKey:KEY_] isKindOfClass:[NSNull class]] ? nil : [JSON_ objectForKey:KEY_]

@implementation Book

-(NSString*)description{
    
    return [NSString stringWithFormat:@"Title: %@\nAuthor: %@\nCategories: %@\nPublisher:%@",self.title, self.author, self.categories, self.publisher];
}

-(void)setBookInfoWithDict:(NSDictionary *)dict{
    self.author             = nilOrJSONObjectForKey(dict, @"author");
    self.categories         = nilOrJSONObjectForKey(dict, @"categories");
    self.lastCheckedOut     = nilOrJSONObjectForKey(dict, @"lastCheckedOut");
    self.lastCheckedOutBy   = nilOrJSONObjectForKey(dict, @"author");
    self.publisher          = nilOrJSONObjectForKey(dict, @"publisher");
    self.title              = nilOrJSONObjectForKey(dict, @"title");
    self.url                = nilOrJSONObjectForKey(dict, @"url");
}
@end
