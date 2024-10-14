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

final class BreedsListModel {
    private var breeds: [Breed] = []
    
    var breedsList: [String] {
        get {
            var answer: [String] = []
            breeds.forEach { breed in
                if let subBreeds = breed.subBreeds, !subBreeds.isEmpty {
                    subBreeds.forEach { subBreed in
                        answer.append(subBreed + " " + breed.title)
                    }
                } else {
                    answer.append(breed.title)
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
}
