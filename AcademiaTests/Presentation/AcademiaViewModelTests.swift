//
//  AcademiaViewModelTests.swift
//  Academia
//
//  Created by Dave on 05/04/25.
//

import XCTest
@testable import Academia

final class AcademiaViewModelTests: XCTestCase {
    
    @MainActor
    func testViewModel_whenOnCreate() async {
        let sut = makeSUT(viewModel: AcademiaViewModel())
        XCTAssertEqual(sut.state, .idle)
    }
    
    // MARK: - Helpers
    
    /// make System Under Test
    @MainActor
    private func makeSUT(
        viewModel: AcademiaViewModel,
        file: StaticString = #file,
        line: UInt = #line,
        checkMemoryLeaks: Bool = true
    ) -> AcademiaViewModel {
        let sut = viewModel
        return sut
    }
    
}
