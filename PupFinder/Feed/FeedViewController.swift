//
//  FeedViewController.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

final class FeedViewController: UIViewController {
    
    let model: BreedsListModel
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.addSubview(refreshControl)
            tableView.register(UINib(nibName: "FeedImageCell", bundle: nil), forCellReuseIdentifier: "FeedImageCell")
        }
    }
    
    init(model: BreedsListModel = BreedsListModel()) {
        self.model = model
        super.init(nibName: "FeedViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        refreshControl.addTarget(self, action: #selector(refreshFeed(_:)), for: .valueChanged)
        refreshFeed()
    }
    
    @objc func refreshFeed(_ sender: Any? = nil) {
        refreshControl.beginRefreshing()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            model.fetchImageFeed {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.feedUrlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as? FeedImageCell else { return UITableViewCell() }
        cell.loadImageFromUrl(url: model.feedUrlList[indexPath.row])
        return cell
    }
}
