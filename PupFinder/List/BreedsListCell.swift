//
//  BreedsListCell.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

class BreedsListCell: UITableViewCell {
    
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
    
    override func prepareForReuse() {
        img.image = UIImage(systemName: "photo.artframe")
        img.tintColor = .gray
        img.alpha = 0.5
    }
    
    func setupCellWith(title: String) {
        self.title.text = title
    }
    
    func setupCellWith(imageData: Data) {
        DispatchQueue.main.async{ [weak self] in
            guard let self else { return }
            img.image = UIImage(data: imageData)
            img.alpha = 1.0
        }
    }
}
