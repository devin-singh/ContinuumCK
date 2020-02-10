//
//  Post.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import CloudKit

struct PostConstants {
    static let typeKey = "Post"
    static let captionKey = "caption"
    static let timestampKey = "timestamp"
    static let commentsKey = "comments"
    static let photoKey = "photo"
    static let commentCountKey = "commentCount"
}

class Post {
    var photoData: Data?
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    var recordID: CKRecord.ID
    var commentCount: Int
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
        
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(recordID.recordName).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage, caption: String, timestamp: Date = Date(), comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.commentCount = commentCount
        self.photo = photo
    }
    
    init?(ckRecord: CKRecord) {
        do{
            guard let caption = ckRecord[PostConstants.captionKey] as? String,
                let timestamp = ckRecord[PostConstants.timestampKey] as? Date,
                let photoAsset = ckRecord[PostConstants.photoKey] as? CKAsset,
                let commentCount = ckRecord[PostConstants.commentCountKey] as? Int,
                let fileURL = photoAsset.fileURL
                else { return nil }
            
            let photoData = try Data(contentsOf: fileURL)
            self.commentCount = commentCount
            self.caption = caption
            self.timestamp = timestamp
            self.photoData = photoData
            self.recordID = ckRecord.recordID
            self.comments = []
        }catch {
            print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
            return nil
        }
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm.lowercased()) {
                    return true
                }
            }
        }
        return false
    }
}
