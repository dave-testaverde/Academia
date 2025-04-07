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
    
    @MainActor
    func testViewModel_whenOnCreate_onDecodingErrorOccurred() async {
        let errorLabel = "test"
        
        let sut = makeSUT(viewModel: AcademiaViewModel())
        sut.onError(err: GetDecodingError.error(cause: errorLabel))
        XCTAssertTrue(sut.onError)
        XCTAssertEqual(sut.errorMsg, errorLabel)
    }
    
    // MARK: - Helpers
    
    /// system under test maker
    @MainActor
    private func makeSUT(
        viewModel: AcademiaViewModel,
        file: StaticString = #file,
        line: UInt = #line,
        checkMemoryLeaks: Bool = true
    ) -> AcademiaViewModel {
        let sut = viewModel
        if(checkMemoryLeaks){
            trackForMemoryLeaks(sut, file: file, line: line)
        }
        return sut
    }
    
}
