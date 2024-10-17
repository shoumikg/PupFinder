//
//  FeedViewController.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

final class FeedViewController: UIViewController {
    
    let model: BreedsListModel
    private var breedName: String?
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.addSubview(refreshControl)
            tableView.register(UINib(nibName: "FeedImageCell", bundle: nil), forCellReuseIdentifier: "FeedImageCell")
        }
    }
    
    init(model: BreedsListModel = BreedsListModel(), breedName: String? = nil) {
        self.model = model
        self.breedName = breedName
        super.init(nibName: "FeedViewController", bundle: nil)
        if let breedName {
            hidesBottomBarWhenPushed = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.breedName == nil ? "Feed" : self.breedName
        refreshControl.addTarget(self, action: #selector(refreshFeed(_:)), for: .valueChanged)
        getMoreImagesForFeed()
    }
    
    @objc func refreshFeed(_ sender: Any? = nil) {
        getMoreImagesForFeed(resetFeed: true)
    }
    
    private func getMoreImagesForFeed(resetFeed: Bool = false) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            model.fetchImageFeed(breedName: breedName, resetFeed: resetFeed) {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.feedUrlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as? FeedImageCell else { return UITableViewCell() }
        cell.loadImageFromUrl(url: model.feedUrlList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 3 == model.feedUrlList.count {
            getMoreImagesForFeed()
        }
    }
}
