//
//  ViewController.swift
//  PupFinder
//
//  Created by Shoumik on 14/10/24.
//

import UIKit

final class BreedsListViewController: UIViewController {
    var model = BreedsListModel()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.addSubview(refreshControl)
            tableView.register(UINib(nibName: "BreedsListCell", bundle: nil), forCellReuseIdentifier: "BreedsListCell")
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func refreshList(_ sender: Any? = nil) {
        model.resetAllBreedsListSampleImages()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Breeds List"
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            model.fetchBreedsList {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    tableView.reloadData()
                }
            }
        }
    }
}

extension BreedsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.breedsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreedsListCell", for: indexPath) as? BreedsListCell else { return UITableViewCell() }
        cell.setupCellWith(title: model.breedsList[indexPath.row])
        model.getBreedsListSample(forIndex: indexPath.row, completion: cell.setupCellWith)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breedFullName = model.breedsList[indexPath.row].components(separatedBy: " ")
        let title = breedFullName.count == 2 ? breedFullName.last! : breedFullName.first!
        let subBreed = breedFullName.count == 2 ? breedFullName.first! : nil
        let sampleVC = BreedSampleViewController(breed: title, subBreed: subBreed)
        self.navigationController?.pushViewController(sampleVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

