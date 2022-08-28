//
//  FeedViewModel.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/25/22.
//

import Foundation
import Combine
import UIKit

class SongFeedViewModel{
    private let service : SongFeedService
    
    private var feedItems = [SongItem]() {
        didSet {
            feedItemSubject.send(feedItems)
        }
    }
    
    @Published private(set) var title : String?
    
    let feedItemSubject = PassthroughSubject<[SongItem], Never>()
    
    init(service: SongFeedService) {
        self.service = service
        loadData()
    }
    
    internal func loadData(completion: (([SongItem]?) -> ())? = nil) {
        Task {
            do {
                if #available(iOS 15.0, *) {
                    if let feedResponse = try await service.getFeed() {
                        DispatchQueue.main.async {
                            self.feedItems = feedResponse.feed.results
                            self.title = feedResponse.feed.title
                            completion?(self.feedItems)
                            return
                        }
                    } else {
                        completion?(nil)
                    }
                } else {
                    service.getFeed { [weak self] result in
                        switch result {
                        case .success(let feedResponse):
                            DispatchQueue.main.async { [weak self] in
                                self?.feedItems = feedResponse.feed.results
                                self?.title = feedResponse.feed.title
                                completion?(self?.feedItems)
                                return
                            }
                        case .failure(_):
                            assertionFailure()
                        }
                    }
                }
            } catch {
                assertionFailure()
            }
        }
        
    }
    
    func getFeedItems() -> [SongItem] {
        return feedItems
    }
}

extension SongFeedViewModel : FeedImageViewDelegate {
    func imageDidLoad(for url: String, image: UIImage?) {
        feedItems.filter { $0.imageURL == url}.forEach { $0.image = image }
    }
}

