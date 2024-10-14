//
//  BreedSampleViewController.swift
//  PupFinder
//
//  Created by Shoumik on 14/10/24.
//

import UIKit

struct BreedSampleResponse: Decodable {
    let message: String
    let status: String
}

class BreedSampleViewController: UIViewController {

    let breed: String
    let subBreed: String?
    
    
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
    
    init(breed: String, subBreed: String? = nil) {
        self.breed = breed
        self.subBreed = subBreed
        super.init(nibName: "BreedSampleViewController", bundle: nil)
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
        let breedRoute = subBreed == nil ? "\(breed)" : "\(breed)/\(subBreed!)"
        image.alpha = 0.5
        let url = URL(string: "https://dog.ceo/api/breed/\(breedRoute)/images/random")!
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self, error == nil else { return }
            if let data = data, !data.isEmpty {
                do {
                    let response = try JSONDecoder().decode(BreedSampleResponse.self, from: data)
                    fetchImageFromURL(url: response.message)
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
    
    private func fetchImageFromURL(url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self, error == nil else { return }
            if let data = data, !data.isEmpty {
                DispatchQueue.main.sync{ [weak self] in
                    guard let self else { return }
                    image.image = UIImage(data: data)
                    image.alpha = 1.0
                }
            }
        }
        task.resume()
    }
}
