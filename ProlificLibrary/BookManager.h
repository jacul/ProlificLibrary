//
//  BookManager.h
//  ProlificLibrary
//
//  Created by zxd on 15/1/14.
//
//  This class manages all books on the server. It can list, update, add and delete books.
//

#import <Foundation/Foundation.h>

#define MSG_BOOKSNEEDUPDATE @"updatebooks"
@class Book;

/**
 * Block used for callbacks.
 * @para response Code of response, can be success or else.
 * @para result An array of Book instance.
 */
typedef void(^finishAction)(NSString* response, NSMutableArray* result);

#define CODE_SUCCESS @"success"

@interface BookManager : NSObject

/**
 * Returns the instance of the manager.
 */
+(BookManager*)instance;

/**
 * List all the books on the server.
 * The block will return the retrieved books.
 * Note the block is not dispatched in main queue.
 */
-(void)listBooks:(finishAction)finish;

/**
 * Retrieve a specific book's information.
 */
-(void)fetchBook:(NSString*)bookURL onFinish:(finishAction)finish;

/**
 * Add a book to the library. The book information will be returned if added successfully.
 */
-(void)addBookWithAuthor:(NSString*)author Tags:(NSString*)tags Title:(NSString*)title Publisher:(NSString*)publisher LastCheckout:(NSString*)checkOutBy onFinish:(finishAction)finish;

/**
 * Delete a book.
 */
-(void)deleteBook:(NSString*)bookURL onFinish:(finishAction)finish;
@end