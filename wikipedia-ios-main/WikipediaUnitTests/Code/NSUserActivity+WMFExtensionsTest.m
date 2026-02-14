#import <XCTest/XCTest.h>
#import "NSUserActivity+WMFExtensions.h"

@interface NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test : XCTestCase
@end

@implementation NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test

- (void)testURLWithoutWikipediaSchemeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"http://www.foo.com"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testInvalidArticleURLReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/wiki/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Foo");
}

- (void)testLocationURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://location?latitude=1.1&longitude=1.2"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLocation);
    XCTAssertEqualObjects(activity.wmf_locationLatitude, @1.1);
    XCTAssertEqualObjects(activity.wmf_locationLongitude, @1.2);
}

- (void)testLocationURLMissingParamReturnsEmptyUserInfo {
    NSURL *url = [NSURL URLWithString:@"wikipedia://location?longitude=1.2"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLocation);
    XCTAssertNil(activity.wmf_locationLatitude);
    XCTAssertNil(activity.wmf_locationLongitude);
}

- (void)testLocationURLWrongParamTyeSetUserInfoToZero {
    NSURL *url = [NSURL URLWithString:@"wikipedia://location?latitude=test&longitude=test"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLocation);
    XCTAssertEqualObjects(activity.wmf_locationLatitude, @0);
    XCTAssertEqualObjects(activity.wmf_locationLongitude, @0);
}

- (void)testExploreURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeExplore);
}

- (void)testSavedURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://saved"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeSavedPages);
}

- (void)testSearchURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/w/index.php?search=dog"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString,
                          @"https://en.wikipedia.org/w/index.php?search=dog&title=Special:Search&fulltext=1");
}

@end
