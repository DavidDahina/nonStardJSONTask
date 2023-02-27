//
//  DetailViewController .swift
//  testTask
//
//  Created by David Dahina on 2/27/23.
//

import Foundation
import UIKit
import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var article: Article?
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    private let detailsLabel = UILabel()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadImages()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        
        // Add subviews to the scroll view
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        stackView.addArrangedSubview(firstImageView)
        stackView.addArrangedSubview(secondImageView)
        stackView.addArrangedSubview(thirdImageView)
        firstImageView.contentMode = .scaleAspectFit
        secondImageView.contentMode = .scaleAspectFit
        thirdImageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(detailsLabel)
        detailsLabel.numberOfLines = 0
        
        // Set up constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdImageView.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            firstImageView.heightAnchor.constraint(equalToConstant: 150),
            secondImageView.heightAnchor.constraint(equalToConstant: 150),
            thirdImageView.heightAnchor.constraint(equalToConstant: 150),
            
            detailsLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    private func loadImages() {
        guard let article = article else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        loadImage(from: article.firstImageURL) { [weak self] image in
            self?.firstImageView.image = image
            group.leave()
        }
        
        group.enter()
        loadImage(from: article.secondImageURL) { [weak self] image in
            self?.secondImageView.image = image
            group.leave()
        }
        
        group.enter()
        loadImage(from: article.thirdImageURL) { [weak self] image in
            self?.thirdImageView.image = image
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.detailsLabel.text = article.details
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
