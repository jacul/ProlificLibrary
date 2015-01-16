//
//  BookManager.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//

#import "BookManager.h"
#import "Book.h"

#define ENDPOINT @"http://prolific-interview.herokuapp.com/54b5aaffb224e90008042473"

static BookManager* _instance;

@implementation BookManager


+(BookManager *)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BookManager new];
    });
    return _instance;
}

/**
 * A method to create NSURLRequest with given path, http method and parameters.
 */
-(NSURLRequest*)createURLWithPath:(NSString*)path Method:(NSString*)httpMethod Param:(NSString*)param{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[ENDPOINT stringByAppendingString:path]]];
    [request setHTTPMethod:httpMethod];
    if (param) {
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return request;
}

-(void)listBooks:(finishAction)finish{
    NSURLRequest* request = [self createURLWithPath:@"/books" Method:@"GET" Param:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (finish==nil) {
            return;
        }
        //Connection error occurs
        if (connectionError) {
            finish(connectionError.localizedDescription, nil);
        }
        
        NSError* error;
        id JSONData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableArray* arrayBooks = [NSMutableArray new];
        
        if ([JSONData isKindOfClass:[NSArray class]])
        {
            NSArray* bookCollection = (NSArray*)JSONData;
            for (NSDictionary* bookInDict in bookCollection) {
                Book* book = [Book new];
                book.author             = bookInDict[@"author"];
                book.categories         = bookInDict[@"categories"];
                book.lastCheckedOut     = bookInDict[@"lastCheckedOut"];
                book.lastCheckedOutBy   = bookInDict[@"lastCheckedOutBy"];
                book.publisher          = bookInDict[@"publisher"];
                book.title              = bookInDict[@"title"];
                book.url                = bookInDict[@"url"];
                [arrayBooks addObject:book];
            }
        }
        
        finish(CODE_SUCCESS, [NSArray arrayWithArray:arrayBooks]);
    }];
    
}


@end
