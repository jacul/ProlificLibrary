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
            return;
        }
        
        NSError* error;
        id JSONData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableArray* arrayBooks = [NSMutableArray new];
        
        if ([JSONData isKindOfClass:[NSArray class]])
        {
            NSArray* bookCollection = (NSArray*)JSONData;
            for (NSDictionary* bookInDict in bookCollection) {
                Book* book = [Book new];
                [book setBookInfoWithDict:bookInDict];
                [arrayBooks addObject:book];
            }
        }
        
        finish(CODE_SUCCESS, arrayBooks);
    }];
    
}

-(void)fetchBook:(NSString *)bookURL onFinish:(finishAction)finish{
    if (bookURL==nil) {
        finish(@"ERROR", nil);
        return;
    }
    NSURLRequest* request = [self createURLWithPath:bookURL Method:@"GET" Param:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (finish==nil) {
            return;
        }
        //Connection error occurs
        if (connectionError) {
            finish(connectionError.localizedDescription, nil);
            return;
        }
        NSError* error;
        id JSONData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableArray* arrayBooks = [NSMutableArray new];
        
        if ([JSONData isKindOfClass:[NSDictionary class]])
        {
            Book* book = [Book new];
            [book setBookInfoWithDict:(NSDictionary*)JSONData];
            [arrayBooks addObject:book];
        }
        
        finish(CODE_SUCCESS, arrayBooks);
    }];
}

-(void)addBook:(Book *)book onFinish:(finishAction)finish{
    if (book == nil || book.author.length==0 || book.title.length==0) {
        finish(@"ERROR", nil);
        return;
    }
    
    NSMutableString* postStr = [NSMutableString new];
    [postStr appendFormat:@"author=%@&", [self urlencode:book.author]];
    [postStr appendFormat:@"categories=%@&", [self urlencode:book.categories]];
    [postStr appendFormat:@"title=%@&", [self urlencode:book.title]];
    [postStr appendFormat:@"publisher=%@&", [self urlencode:book.publisher]];
    [postStr appendFormat:@"lastCheckedOutBy=%@", [self urlencode:book.lastCheckedOutBy]];
    
    NSURLRequest* request = [self createURLWithPath:@"/books/" Method:@"POST" Param:postStr];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (finish==nil) {
            return;
        }
        //Connection error occurs
        if (connectionError) {
            finish(connectionError.localizedDescription, nil);
            return;
        }
        NSError* error;
        id JSONData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableArray* arrayBooks = [NSMutableArray new];
        
        if ([JSONData isKindOfClass:[NSDictionary class]])
        {
            Book* book = [Book new];
            [book setBookInfoWithDict:(NSDictionary*)JSONData];
            [arrayBooks addObject:book];
        }
        
        finish(CODE_SUCCESS, arrayBooks);
    }];
}

-(void)deleteBook:(NSString *)bookURL onFinish:(finishAction)finish{
    if (bookURL==nil) {
        finish(@"ERROR", nil);
        return;
    }
    
    NSURLRequest* request = [self createURLWithPath:bookURL Method:@"DELETE" Param:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (finish==nil) {
            return;
        }
        //Connection error occurs
        if (connectionError) {
            finish(connectionError.localizedDescription, nil);
            return;
        }
        if ([(NSHTTPURLResponse*)response statusCode] == 204) {
            
            finish(CODE_SUCCESS, nil);
        }else{
            
            finish(@"ERROR", nil);
        }
        
    }];
}

/**
 * Helper function to url encode a string
 */
- (NSString *)urlencode:(NSString*)str {
    if (str==nil) {
        return @"";
    }
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)str,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    return encodedString;
}

@end
