//
//  AlertPromptView.h
//  mJob
//
//  Created by Jeff Lamarche
//  see http://iphonedevelopment.blogspot.com/2009/02/alert-view-with-prompt.html
//

#import <UIKit/UIKit.h>

@interface AlertPromptView : UIAlertView 
{
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;

// the |message| argument will not be shown. Nevertheless, for spacing reasons, just put in a few words of dummy text.
- (id)initWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder text:(NSString *)text delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle;
@end