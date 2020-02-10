//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    // MARK: - Properties
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    // MARK: - Functions
    
    func updateViews() {
        guard let post = post else { return }
        postImageView.image = post.photo
        captionLabel.text = post.caption
        commentCountLabel.text = String(post.commentCount)
    }
    
}
