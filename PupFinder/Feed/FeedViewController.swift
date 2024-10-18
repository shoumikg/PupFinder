//
//  FeedViewController.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

final class FeedViewController: UIViewController {
    
    let listModel: BreedsListModel
    let feedModel: ImageFeedModel
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
    
    init(listModel: BreedsListModel = BreedsListModel(), breedName: String? = nil, feedModel: ImageFeedModel = ImageFeedModel()) {
        self.listModel = listModel
        self.breedName = breedName
        self.feedModel = feedModel
        super.init(nibName: "FeedViewController", bundle: nil)
        if breedName != nil {
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
            feedModel.fetchImageFeed(breedName: breedName, resetFeed: resetFeed) {
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
        feedModel.feedUrlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as? FeedImageCell else { return UITableViewCell() }
        cell.loadImageFromUrl(url: feedModel.feedUrlList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == feedModel.feedUrlList.count {
            getMoreImagesForFeed()
        }
    }
}
