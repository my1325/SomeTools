//
//  ViewController.h
//  sdfsdafdsafa
//
//  Created by my on 2023/2/28.
//

#import <UIKit/UIKit.h>

@protocol AdProtocol;

@protocol TestDelegate <NSObject>
- (void)asdfdsaf;

@property(atomic, assign) NSInteger a;
@end

@protocol ViewControllerDelegate
@required
@property NSString * a;

- (void)sadfasdf;

-(NSString *)asdf: (id)b sadf:(NSString*)c;

+(NSURL *)asdf;

@optional
@property(nonatomic, strong) NSString* b;
- (void)asdf;
-(NSString *)asdfasdfadsf;
@end

@interface ViewController : UIViewController

@property NSString *asdf;

- (void)asdfjlff;

-(void)asdfjlsdajf;

-(void)safsdafjsdalkfjlsda;
@end

@interface ViewController()
@property NSString *asdfasdf;
@property NSString *asdfsdafasdfsda;
@property NSString *asdfasasdfdf;
@property NSString *asdfq23asdf;
@end


@interface ViewController(asldjflkdsajflk)
@property NSString *asdfasdf;
@property NSString *asdfsdafasdfsda;
@property NSString *asdfasasdfdf;
@property NSString *asdfq23asdf;
- (void)asdfjlff;

-(void)asdfjlsdajf;

-(void)safsdafjsdalkfjlsda;
@end