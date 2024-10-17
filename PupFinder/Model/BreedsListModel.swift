//
//  BreedsListModel.swift
//  PupFinder
//
//  Created by Shoumik on 14/10/24.
//

import Foundation

struct Breed {
    let title: String
    let subBreeds: [String]?
}

struct ListAllBreedsResponse: Decodable {
    let message: [String:[String]]
    let status: String
}

struct BreedSampleResponse: Decodable {
    let message: String
    let status: String
}

struct FeedResponse: Decodable {
    let message: [String]
    let status: String
}

final class BreedsListModel {
    private var breeds: [Breed]
    private var breedsUrlList: [String] {
        get {
            guard _breedsUrlList.isEmpty else { return _breedsUrlList }
            _breedsUrlList = breedsList.map { breedName in
                let (breed, subBreed) = getBreedSubBreedFrom(breedName)
                let breedRoute = subBreed == nil ? "\(breed.lowercased())" : "\(breed.lowercased())/\(subBreed!.lowercased())"
                return "https://dog.ceo/api/breed/\(breedRoute)/images/random"
            }
            return _breedsUrlList
        }
    }
    private var _breedsUrlList = [String]()
    private var breedsListImageSample = [Data?]()
    private var _breedsList = [String]()
    var breedsList: [String] {
        get {
            guard _breedsList.isEmpty else { return _breedsList }
            var answer: [String] = []
            breeds.forEach { breed in
                if let subBreeds = breed.subBreeds, !subBreeds.isEmpty {
                    subBreeds.forEach { subBreed in
                        answer.append(subBreed.capitaliseFirstLetter() + " " + breed.title.capitaliseFirstLetter())
                    }
                } else {
                    answer.append(breed.title.capitaliseFirstLetter())
                }
            }
            _breedsList = answer
            self.resetAllBreedsListSampleImages()
            return answer
        }
    }
    
    var feedUrlList: [String]
    
    init(breeds: [Breed] = [],
         feedUrlList: [String] = []) {
        self.breeds = breeds
        self.feedUrlList = feedUrlList
    }
    
    private func getBreedSubBreedFrom(_ breedName: String) -> (String, String?) {
        let breedNameComponents = breedName.components(separatedBy: " ")
        let breed = breedNameComponents.count == 2 ? breedNameComponents.last! : breedNameComponents.first!
        let subBreed = breedNameComponents.count == 2 ? breedNameComponents.first! : nil
        return (breed, subBreed)
    }
    
    func resetAllBreedsListSampleImages() {
        breedsListImageSample = [Data?](repeating: Data(), count: _breedsList.count)
    }
    
    func getBreedsListSample(forIndex: Int, completion: @escaping (Data) -> ()) {
        guard forIndex < breedsListImageSample.count, breedsListImageSample[forIndex] == Data() else {
            if forIndex < breedsListImageSample.count {
                completion(breedsListImageSample[forIndex] ?? Data())
            } else {
                completion(Data())
            }
            return
        }
        let (breed, subBreed) = getBreedSubBreedFrom(breedsList[forIndex])
        fetchSampleFor(breed: breed, subBreed: subBreed) { [weak self] data in
            guard let self else { return }
            breedsListImageSample[forIndex] = data
            completion(data)
        }
    }
    
    func fetchBreedsList(completion: (() -> ())? = nil) {
        guard breeds.isEmpty else { return }
        let url = URL(string: "https://dog.ceo/api/breeds/list/all")!
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard error == nil else { return }
            if let data = data, !data.isEmpty {
                do {
                    let response = try JSONDecoder().decode(ListAllBreedsResponse.self, from: data)
                    var answer = [Breed]()
                    response.message.forEach { (breed: String, subBreeds: [String]) in
                        answer.append(Breed(title: breed, subBreeds: subBreeds))
                    }
                    self.breeds = answer.sorted(by: { $0.title < $1.title })
                    completion?()
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
    
    func fetchImageFromURL(url: String, 
                           completion: @escaping (Data) -> Void) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else { return }
            if let data = data, !data.isEmpty {
                completion(data)
            }
        }
        task.resume()
    }
    
    func fetchImageFeed(resetFeed: Bool, 
                        completion: @escaping () -> ()) {
        let urlRequest = URLRequest(url: URL(string: "https://dog.ceo/api/breeds/image/random/10")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self, error == nil else { return }
            if let data = data, !data.isEmpty {
                let result = try? JSONDecoder().decode(FeedResponse.self, from: data)
                if resetFeed {
                    feedUrlList = []
                }
                self.feedUrlList.append(contentsOf: result?.message ?? [])
                completion()
            }
        }
        task.resume()
    }
    
    func fetchSampleFor(breed: String, 
                        subBreed: String?,
                        completion: @escaping (Data) -> Void) {
        let breedRoute = subBreed == nil ? "\(breed.lowercased())" : "\(breed.lowercased())/\(subBreed!.lowercased())"
        let url = URL(string: "https://dog.ceo/api/breed/\(breedRoute)/images/random")!
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self, error == nil else { return }
            if let data = data, !data.isEmpty {
                do {
                    let response = try JSONDecoder().decode(BreedSampleResponse.self, from: data)
                    DispatchQueue.global().async { [weak self] in
                        guard let self else { return }
                        self.fetchImageFromURL(url: response.message, completion: completion)
                    }
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
}
