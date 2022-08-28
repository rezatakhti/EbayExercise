//
//  SongCollectionViewCell.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/25/22.
//

import UIKit
import SwiftUI

class FeedCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "SongCollectionViewCell"
    
    let imageView : FeedImageView = {
        let iv = FeedImageView()
        return iv
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let subtitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true 
        label.numberOfLines = 2
        return label
    }()
    
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    private func setupViews(){
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 15
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.constrain(toView: self.contentView, top: 8, left: 8)
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        contentView.addSubview(stackView)
        stackView.constrain(toView: self.contentView, top: 8, right: 8, bottom: 8)
        stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    func setup(with feedItem: any FeedItem){
        titleLabel.text = feedItem.title
        subtitleLabel.text = feedItem.subTitle
        
        guard feedItem.image == nil else {
            imageView.image = feedItem.image
            return
        }
        
        Task {
            do {
                if #available(iOS 15.0, *) {
                    try await imageView.loadImage(at: feedItem.imageURL)
                } else {
                    imageView.loadImage(at: feedItem.imageURL) { result in
                        switch result {
                        case .success(_):
                            break
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = CGFloat(ceilf(Float(size.height)))
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
