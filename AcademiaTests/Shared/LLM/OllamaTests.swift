//
//  OllamaTests.swift
//  Academia
//
//  Created by Dave on 09/04/25.
//

import XCTest
@testable import Academia

final class OllamaTests: XCTestCase {
    
    let academiaViewModelTests: AcademiaViewModelTests = AcademiaViewModelTests()
    let ollama: Ollama = Ollama()
    
    @MainActor
    func testOllama_whenOnGenerate_stateChange() async {
        let sut = makeSUT(viewModel: AcademiaViewModel(), checkMemoryLeaks: false)
        
        await academiaViewModelTests.testViewModel_whenOnCreate()
        do {
            try await ollama.onTapGeneration()
            XCTAssertEqual(sut.state, .loading)
        } catch {
            print("[ERROR] \(error.localizedDescription)")
            XCTFail()
        }
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
        ollama.viewModel = sut
        return sut
    }
    
}
