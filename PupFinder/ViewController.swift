//
//  ViewController.swift
//  PupFinder
//
//  Created by Shoumik on 14/10/24.
//

import UIKit

final class ViewController: UIViewController {
    var model = BreedsListModel()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.addSubview(refreshControl)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func refreshList(_ sender: Any? = nil) {
        model.fetchBreedsList { [weak self] in
            DispatchQueue.main.sync{
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Breeds List"
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        self.refreshControl.beginRefreshing()
        refreshList()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.breedsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedsListCell", for: indexPath)
        cell.textLabel?.text = model.breedsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breedFullName = model.breedsList[indexPath.row].components(separatedBy: " ")
        let title = breedFullName.count == 2 ? breedFullName.last! : breedFullName.first!
        let subBreed = breedFullName.count == 2 ? breedFullName.first! : nil
        let sampleVC = BreedSampleViewController(breed: title, subBreed: subBreed)
        self.navigationController?.pushViewController(sampleVC, animated: true)
    }
}

