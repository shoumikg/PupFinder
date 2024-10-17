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
    private var breeds: [Breed] = []
    var feedUrlList: [String] = []
    
    var breedsList: [String] {
        get {
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
            return answer
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
