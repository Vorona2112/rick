//
//  EpisodesViewController.swift
//  rick and morty
//
//  Created by user on 27.07.2024.
//

import UIKit

class EpisodesViewController: UIViewController {

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Episodes"
        
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EpisodeCell")
        view.addSubview(tableView)
    }
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of episodes
        return 10 // Placeholder
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
        cell.textLabel?.text = "Episode \(indexPath.row)" // Placeholder
        return cell
    }
}
