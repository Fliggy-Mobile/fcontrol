#import "FcontrolPlugin.h"
#if __has_include(<fcontrol/fcontrol-Swift.h>)
#import <fcontrol/fcontrol-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fcontrol-Swift.h"
#endif

@implementation FcontrolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFcontrolPlugin registerWithRegistrar:registrar];
}
@end
