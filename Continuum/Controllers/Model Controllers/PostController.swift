//
//  PostController.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    //MARK: - CRUD Methods
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        let record = CKRecord(comment: comment)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let record = record else { completion(nil) ; return }
            let comment = Comment(ckRecord: record, post: post)
            self.incrementCommentCount(for: post, completion: nil)
            completion(comment)
        }
    }
    
    func createPostWith(photo: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: photo, caption: caption)
        self.posts.append(post)
        
        let record = CKRecord(post: post)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let record = record,
                let post = Post(ckRecord: record)  else { completion(nil) ; return }
            completion(post)
        }
    }
    
    //MARK: - Read Methods
    func fetchPosts(completion: @escaping ([Post]?) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.typeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil) ; return }
            let posts = records.compactMap{ Post(ckRecord: $0) }
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> Void){
        let postRefence = post.recordID
        
        let predicate = NSPredicate(format: "%K == %@", CommentConstants.postReferenceKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching comments from cloudKit \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let comments = records.compactMap{ Comment(ckRecord: $0, post: post) }
            post.comments.append(contentsOf: comments)
            completion(comments)
        }
    }
    
    //MARK: - Update Methods
    func incrementCommentCount(for post: Post, completion: ((Bool)-> Void)?){
        
        post.commentCount += 1
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        
        modifyOperation.savePolicy = .changedKeys
        
        modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else {
                completion?(true)
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(modifyOperation)
    }
}
