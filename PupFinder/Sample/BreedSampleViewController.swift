//
//  BreedSampleViewController.swift
//  PupFinder
//
//  Created by Shoumik on 14/10/24.
//

import UIKit

final class BreedSampleViewController: UIViewController {

    let breed: String
    let subBreed: String?
    let model: BreedsListModel
    
    @IBOutlet weak var image: UIImageView! {
        didSet {
            image.image = UIImage(systemName: "photo.artframe")
            image.tintColor = .gray
            image.alpha = 0.5
        }
    }
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle("Shuffle", for: .normal)
        }
    }
    
    init(breed: String, subBreed: String? = nil, model: BreedsListModel = BreedsListModel()) {
        self.breed = breed
        self.subBreed = subBreed
        self.model = model
        super.init(nibName: "BreedSampleViewController", bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = breed + " " + (subBreed ?? "")
        fetchNewSample()
    }

    @IBAction func fetchNewSample(_ sender: Any? = nil) {
        let breedRoute = subBreed == nil ? "\(breed.lowercased())" : "\(breed.lowercased())/\(subBreed!.lowercased())"
        image.alpha = 0.5
        let url = URL(string: "https://dog.ceo/api/breed/\(breedRoute)/images/random")!
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self, error == nil else { return }
            if let data = data, !data.isEmpty {
                do {
                    let response = try JSONDecoder().decode(BreedSampleResponse.self, from: data)
                    DispatchQueue.global().async { [weak self] in
                        guard let self else { return }
                        model.fetchImageFromURL(url: response.message) { [weak self] imageData in
                            guard let self else { return }
                            DispatchQueue.main.async { [weak self] in
                                guard let self else { return }
                                image.image = UIImage(data: imageData)
                                image.alpha = 1.0
                            }
                        }
                    }
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
}
