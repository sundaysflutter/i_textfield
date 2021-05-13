#import "ITextfieldPlugin.h"
#if __has_include(<i_textfield/i_textfield-Swift.h>)
#import <i_textfield/i_textfield-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "i_textfield-Swift.h"
#endif

@implementation ITextfieldPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftITextfieldPlugin registerWithRegistrar:registrar];
}
@end
