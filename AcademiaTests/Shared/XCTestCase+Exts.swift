//
//  XCTestCase+Exts.swift
//  Academia
//
//  Created by Dave on 06/04/25.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak! The instance should have been deallocated.", file: file, line: line)
        }
    }
}
