//
//  SongFeedController.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/24/22.
//

import UIKit
import Combine
import SwiftUI

class SongFeedController: UIViewController {
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - (16), height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        cv.backgroundColor = .secondarySystemBackground
        
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let viewModel : SongFeedViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SongFeedViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    private func setupBindings(){
        viewModel.feedItemSubject.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
        viewModel.$title.sink { [weak self] title in
            if let title = title {
                self?.title = title
            }
        }.store(in: &cancellables)
    }
    
    private func setupViews(){
        view.addSubview(collectionView)
        collectionView.constrain(toView: self.view, top: 8, left: 8, right: 8, bottom: 8)
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension SongFeedController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getFeedItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
        cell.setup(with: viewModel.getFeedItems()[indexPath.row])
        cell.imageView.delegate = viewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(UIHostingController(rootView: SongFeedDetailView(feedItem: viewModel.getFeedItems()[indexPath.row])), animated: true)
    }
    
    
}

