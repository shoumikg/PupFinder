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
                    self.breeds = answer
                    completion?()
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
    
    func fetchImageFromURL(url: String, completion: @escaping (Data) -> Void) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else { return }
            if let data = data, !data.isEmpty {
                DispatchQueue.main.sync{
                    completion(data)
                }
            }
        }
        task.resume()
    }
    
    func fetchImageFeed(completion: @escaping () -> ()) {
        let urlRequest = URLRequest(url: URL(string: "https://dog.ceo/api/breeds/image/random/50")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self, error == nil else { return }
            if let data = data, !data.isEmpty {
                let result = try? JSONDecoder().decode(FeedResponse.self, from: data)
                self.feedUrlList = result?.message ?? []
                DispatchQueue.main.sync{
                    completion()
                }
            }
        }
        task.resume()
    }
}
