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
@end
