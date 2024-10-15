//
//  FeedImageCell.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

class FeedImageCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView! {
        didSet {
            img.image = UIImage(systemName: "photo.artframe")
            img.tintColor = .gray
            img.alpha = 0.5
        }
    }
    
    let model = BreedsListModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImageFromUrl(url: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            model.fetchImageFromURL(url: url) { imageData in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    img.image = UIImage(data: imageData)
                    img.alpha = 1.0
                }
            }
        }
    }
    
}
