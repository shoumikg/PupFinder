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
        image.alpha = 0.5
        model.fetchSampleFor(breed: breed, subBreed: subBreed) { [weak self] imageData in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                image.image = UIImage(data: imageData)
                image.alpha = 1.0
            }
        }
    }
}
