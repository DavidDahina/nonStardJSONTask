//
//  ViewController.swift
//  testTask
//
//  Created by David Dahina on 2/26/23.
//

import UIKit

class ViewController: UIViewController {

    // create UITableView
    let tableView = UITableView()
    
    // create data array for TableView
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "task", withExtension: "json") else {
            fatalError("Could not find file in bundle")
        }

        var jsonString: String

        do {
            let jsonData = try Data(contentsOf: url)
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            fatalError("Could not load file: \(error)")
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Invalid JSON data")
            return
        }

        do {
            articles = try ArticleParser.parse(jsonData: jsonData)
            //print(articles)
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
        
        // setup UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // set constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let detailsVC = DetailsViewController()
        detailsVC.article = article
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
