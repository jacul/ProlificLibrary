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
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
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
        
        NSMutableArray* arrayBooks = [self retrieveBooksInfoFromJSONData:data];
        
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
        
        NSMutableArray* arrayBooks = [self retrieveBooksInfoFromJSONData:data];
        
        finish(CODE_SUCCESS, arrayBooks);
    }];
}

-(void)addBook:(Book *)book onFinish:(finishAction)finish{
    if (book == nil || book.author.length==0 || book.title.length==0) {
        finish(@"ERROR", nil);
        return;
    }
    
    NSString* postStr = [book URLEncodedString];
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
        
        NSMutableArray* arrayBooks = [self retrieveBooksInfoFromJSONData:data];
        
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

-(void)updateBook:(Book *)oldBook withNewBook:(Book *)newBook onFinish:(finishAction)finish{
    if (oldBook == nil || newBook == nil || oldBook.url == nil) {
        finish(@"ERROR", nil);
        return;
    }
    
    NSString* postStr = [newBook URLEncodedString];
    NSURLRequest* request = [self createURLWithPath: oldBook.url Method:@"PUT" Param:postStr];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (finish==nil) {
            return;
        }
        //Connection error occurs
        if (connectionError) {
            finish(connectionError.localizedDescription, nil);
            return;
        }
        
        NSMutableArray* arrayBooks = [self retrieveBooksInfoFromJSONData:data];
        
        finish(CODE_SUCCESS, arrayBooks);
        
    }];
    
}

-(void)deleteAll:(finishAction)finish{
    NSURLRequest* request = [self createURLWithPath:@"/clean" Method:@"DELETE" Param:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (finish==nil) {
            return;
        }
        //Connection error occurs
        if (connectionError) {
            finish(connectionError.localizedDescription, nil);
            return;
        }
        if ([(NSHTTPURLResponse*)response statusCode] == 200) {
            
            finish(CODE_SUCCESS, nil);
        }else{
            
            finish(@"ERROR", nil);
        }
        
    }];
}

/**
 * Create an array of Book from JSON data.
 * If the given data is not valid, an empty array will be returned.
 */
-(NSMutableArray*)retrieveBooksInfoFromJSONData:(NSData*)jsondata{
    NSError* error;
    id JSONData = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:&error];

    NSMutableArray* arrayBooks = [NSMutableArray new];
    
    if ([JSONData isKindOfClass:[NSDictionary class]])
    {
        Book* book = [Book new];
        [book setBookInfoWithDict:(NSDictionary*)JSONData];
        [arrayBooks addObject:book];
    }else if ([JSONData isKindOfClass:[NSArray class]])
    {
        NSArray* bookCollection = (NSArray*)JSONData;
        for (NSDictionary* bookInDict in bookCollection) {
            Book* book = [Book new];
            [book setBookInfoWithDict:bookInDict];
            [arrayBooks addObject:book];
        }
    }
    return arrayBooks;
}

@end
