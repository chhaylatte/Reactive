import XCTest

import ReactiveTests

var tests = [XCTestCaseEntry]()
tests += ReactiveTests.allTests()
XCTMain(tests)
