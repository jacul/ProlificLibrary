# ProlificLibrary
A simple library management app to list and manage the books in the library.

##Functions
List books
Add book
Edit book
Check out a book
Delete book/all books

##Program flow:

                          +                                      
                          | Entry                                
                          |                                      
              +-----------v----------+         +----------------+
              |                      |         |                |
              |  RootViewController  |         | SideMenu       |
              |                      +---------+ ViewController |
              |                      |         |  Clean all     |
              |                      |         |  About         |
              +-----------+----------+         +----------------+
                          |                                      
                          |                                      
              +-----------v----------+                           
              |                      |                           
              |BookListViewController|                           
              |                      |                           
              |   TableView          |                           
              |    List all books    |                           
              |    Drag to refresh   |                           
              |                      |                           
              +-----+-----------+----+                           
                    |           |                                
                    |           |                                
                    |           |                                
                    |           |                                
         Add button |           |didSelectRowAtIndexPath         
        +-----------+           +-----------------------+        
        |                                               |        
+-------v-------------------+       +-------------------v-------+
|                           |       |                           |
|  AddBookViewController    |       | BookDetailsViewController |
|                           |       |                           |
|    Enter book info        |       |    Display book info      |
|                           |       |                           |
|    Submit                 |       |    Check out              |
|                           |       |                           |
+---------------------------+       +-------------+-------------+
                                                  |              
                                                  |              
                                                  |              
                                                  |              
                                                  |              
                                    +-------------v-------------+
                                    |                           |
                                    | EditBookViewController    |
                                    |                           |
                                    | Display given book info   |
                                    |                           |
                                    | Edit and submit           |
                                    |                           |
                                    +---------------------------+


##Thrid party libraries

ODRefreshControl
RESideMenu