//
//  OllamaTests.swift
//  Academia
//
//  Created by Dave on 09/04/25.
//

import XCTest
@testable import Academia

final class OllamaTests: XCTestCase {
    
    /// size this parameters based on response time of LLM for your machine
    let OLLAMA_LATENCY_SEC = 15.0
    let OLLAMA_TIME_TO_GENERATE_PAYLOAD = 18.0
    
    let academiaViewModelTests: AcademiaViewModelTests = AcademiaViewModelTests()
    let ollama: Ollama = Ollama()
    
    @MainActor
    func testOllama_whenOnGenerate_stateChange() async {
        let sut = makeSUT(viewModel: AcademiaViewModel(), checkMemoryLeaks: false)
        
        XCTAssertEqual(sut.state, .idle)
        do {
            try await ollama.onTapGeneration()
            XCTAssertEqual(sut.state, .loading)
        } catch {
            print("[ERROR] \(error.localizedDescription)")
            XCTFail()
        }
    }
    
    @MainActor
    func testOllama_whenOnGenerate_stateChange_withoutViewModel() async {
       // TODO
    }
    
    @MainActor
    func testOllama_whenOnGenerate_streamStarted() async {
        let sut = makeSUT(viewModel: AcademiaViewModel(), checkMemoryLeaks: false)
        
        do {
            try await ollama.onTapGeneration()
        } catch { XCTFail() }
        
        let expectation = XCTestExpectation(description: "Ollama stream started")
        DispatchQueue.main.asyncAfter(deadline: .now() + OLLAMA_LATENCY_SEC, execute: {
            print("message \(sut.message)")
            XCTAssertFalse(sut.message.isEmpty)
            expectation.fulfill()
        })
        await fulfillment(of: [expectation])
    }
    
    @MainActor
    func testOllama_whenOnGenerate_responseLoaded() async {
        let sut = makeSUT(viewModel: AcademiaViewModel(), checkMemoryLeaks: false)
        
        do {
            try await ollama.onTapGeneration()
        } catch { XCTFail() }
        
        let expectation = XCTestExpectation(description: "Ollama response loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + OLLAMA_LATENCY_SEC + OLLAMA_TIME_TO_GENERATE_PAYLOAD, execute: {
            XCTAssertEqual(sut.state, .loaded)
            expectation.fulfill()
        })
        await fulfillment(of: [expectation])
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
