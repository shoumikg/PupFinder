//
//  BreedsListCell.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

class BreedsListCell: UITableViewCell {
    
    let model = BreedsListModel()
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView! {
        didSet {
            img.image = UIImage(systemName: "photo.artframe")
            img.tintColor = .gray
            img.alpha = 0.5
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWithData(title: String) {
        self.title.text = title
        /*guard !imageLoaded else { return }
        let breedFullName = title.components(separatedBy: " ")
        let breed = breedFullName.count == 2 ? breedFullName.last! : breedFullName.first!
        let subBreed = breedFullName.count == 2 ? breedFullName.first! : nil
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.model.fetchSampleFor(breed: breed, subBreed: subBreed) { imageData in
                DispatchQueue.main.async{ [weak self] in
                    guard let self else { return }
                    img.image = UIImage(data: imageData)
                    img.alpha = 1.0
                    imageLoaded = true
                }
            }
        }*/
    }
}
