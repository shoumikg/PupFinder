//
//  BreedsListModelTests.swift
//  PupFinderTests
//
//  Created by Shoumik on 18/10/24.
//

import XCTest
@testable import PupFinder

final class BreedsListModelTests: XCTestCase {
    func test_init_isEmptyOnInit() {
        //Given
        let sut = BreedsListModel()
        
        //When
        
        //Then
        XCTAssertEqual(sut.breedsList, [])
    }
    
    func test_fetchBreedsList_setsBreedsList() {
        //Given
        let sut = BreedsListModel()
        let exp = expectation(description: "wait for breeds list fetch")
        
        //When
        sut.fetchBreedsList {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        //Then
        XCTAssertNotEqual(sut.breedsList, [])
    }
    
    func test_getBreedSubBreedFrom_getsBreedSubbreed() {
        //Given
        let sut = BreedsListModel()
        let breedName1 = "Australian Shepherd"
        let breedName2 = "Shiba"
        let breedName3 = ""
        
        //When
        let (breed1, subBreed1) = BreedsListModel.getBreedSubBreedFrom(breedName1)
        let (breed2, subBreed2) = BreedsListModel.getBreedSubBreedFrom(breedName2)
        let (breed3, subBreed3) = BreedsListModel.getBreedSubBreedFrom(breedName3)
        
        //Then
        XCTAssertEqual(breed1, "Shepherd")
        XCTAssertEqual(subBreed1, "Australian")
        XCTAssertEqual(breed2, "Shiba")
        XCTAssertEqual(subBreed2, nil)
        XCTAssertEqual(breed3, "")
        XCTAssertEqual(subBreed3, nil)
    }
}
