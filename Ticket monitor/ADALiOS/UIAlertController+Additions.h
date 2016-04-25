#import <UIKit/UIKit.h>

@interface UIAlertController (Additions)

+ (void)presentCredentialAlert:(void(^)(NSUInteger index))handler;

+ (id) getAlertInstance;
@end