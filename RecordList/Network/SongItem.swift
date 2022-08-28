//
//  SongItem.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/24/22.
//

import UIKit

protocol FeedItem : AnyObject {
    var title : String { get }
    var subTitle : String { get }
    var date : String { get }
    var imageURL : String { get }
    var image: UIImage? { get set }
    var url: String { get }
}

protocol CodableFeedItem : FeedItem, Codable { }

protocol FeedResponse {
    associatedtype T : Feed
    var feed: T { get }
}

protocol CodableFeedResponse : FeedResponse, Codable { }

struct SongFeedResponse: CodableFeedResponse {
    let feed : SongFeed
}

protocol Feed : Codable {
    associatedtype T : FeedItem
    var results : [T] { get }
    var title : String { get }
}

struct SongFeed : Feed {
    let results: [SongItem]
    let title : String
}

class SongItem: CodableFeedItem, Codable, ObservableObject {
    let title: String
    let subTitle: String
    let date: String
    let imageURL: String
    var image: UIImage?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title = "name", subTitle = "artistName", date = "releaseDate", imageURL = "artworkUrl100", url
    }
}
