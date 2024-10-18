//
//  BreedsListModelTests.swift
//  PupFinderTests
//
//  Created by Shoumik on 18/10/24.
//

import XCTest
@testable import PupFinder

final class BreedsListModelTests: XCTestCase {
    
    var sut: BreedsListModel!
    
    override func setUp() {
        super.setUp()
        let breeds = [
            Breed(title: "Labrador", subBreeds: nil),
            Breed(title: "Bulldog", subBreeds: ["English", "French"]),
            Breed(title: "Poodle", subBreeds: ["Toy", "Miniature", "Standard"])
        ]
        sut = BreedsListModel(breeds: breeds)
    }
    
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
    
    func testBreedsList() {
        // Test that the breedsList is correctly populated
        let expectedBreedsList = [
            "Labrador",
            "English Bulldog",
            "French Bulldog",
            "Toy Poodle",
            "Miniature Poodle",
            "Standard Poodle"
        ]
        XCTAssertEqual(sut.breedsList, expectedBreedsList)
    }
    
    func testGetBreedSubBreedFrom() {
        // Test static method for generating breed and sub-breed from name
        let (breed, subBreed) = BreedsListModel.getBreedSubBreedFrom("Miniature Poodle")
        XCTAssertEqual(breed, "Poodle")
        XCTAssertEqual(subBreed, "Miniature")
        
        let (singleBreed, noSubBreed) = BreedsListModel.getBreedSubBreedFrom("Labrador")
        XCTAssertEqual(singleBreed, "Labrador")
        XCTAssertNil(noSubBreed)
    }
    
    func testFetchBreedsList() {
        // Mocking network request
        let expectation = self.expectation(description: "Fetching breeds list")
        sut.fetchBreedsList {
            // Assuming the sut should update breeds based on the response
            XCTAssertFalse(self.sut.breedsList.isEmpty)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchImageFromURL() {
        // Mocking an image download
        let url = "https://dog.ceo/api/breed/labrador/images/random"
        let expectation = self.expectation(description: "Fetching image data")
        
        sut.fetchImageFromURL(url: url) { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
