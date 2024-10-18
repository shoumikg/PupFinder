//
//  File.swift
//  PupFinder
//
//  Created by Shoumik on 18/10/24.
//

import Foundation

struct FeedResponse: Decodable {
    let message: [String]
    let status: String
}

final class ImageFeedModel {
    
    var feedUrlList: [String]
    
    init(feedUrlList: [String] = []) {
        self.feedUrlList = feedUrlList
    }
    
    func fetchImageFeed(breedName: String? = nil,
                        resetFeed: Bool,
                        completion: @escaping () -> ()) {
        var url = "https://dog.ceo/api/breeds/image/random/10"
        if let breedName {
            let (breed, subBreed) = BreedsListModel.getBreedSubBreedFrom(breedName)
            let breedRoute = subBreed == nil ? "\(breed.lowercased())" : "\(breed.lowercased())/\(subBreed!.lowercased())"
            url = "https://dog.ceo/api/breed/\(breedRoute)/images/random/10"
        }
        let urlRequest = URLRequest(url: URL(string: url)!)
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
    
}
