#import "DatecsPrinterPlugin.h"
#if __has_include(<datecs_printer/datecs_printer-Swift.h>)
#import <datecs_printer/datecs_printer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "datecs_printer-Swift.h"
#endif

@implementation DatecsPrinterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDatecsPrinterPlugin registerWithRegistrar:registrar];
}
@end
