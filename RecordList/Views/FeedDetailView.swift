//
//  SongFeedDetailView.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/25/22.
//

import SwiftUI

struct SongFeedDetailView: View {
    
    @ObservedObject var feedItem : SongItem
    
    var body: some View {
        VStack {
            if let image = feedItem.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                Text(feedItem.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text(feedItem.subTitle)
                    .font(.body)
                Text(feedItem.date)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                if let url = URL(string: feedItem.url) {
                    Link("View on Apple Music", destination: url)
                }
            }
            
        }.padding()
        Spacer()
        
    }
}
