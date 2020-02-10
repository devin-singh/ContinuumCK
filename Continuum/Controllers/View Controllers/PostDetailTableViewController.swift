//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var followPostButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        presentCommentAlertController()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let postPhoto = post?.photo, let postCaption = post?.caption else { return }
        let activityVC = UIActivityViewController(activityItems: [postPhoto, postCaption], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        guard let post = post else { return }
          PostController.shared.toggleSubscriptionTo(commentsForPost: post, completion: { (success, error) in
            if let error = error{
              print("\(error.localizedDescription) \(error) in function: \(#function)")
              return
            }
            self.updateFollowPostButtonText()
          })
    }
    
    // MARK: - Functions
    
    func updateViews() {
        guard let post = post else { return }
        postImageView.image = post.photo
        updateFollowPostButtonText()
        tableView.reloadData()
    }
    
    func updateFollowPostButtonText(){
      guard let post = post else { return }
      //Check CloudKit for a subscription to this post and adjust the text of the button to reflect this
      PostController.shared.checkForSubscription(to: post) { (found) in
        DispatchQueue.main.async {
          let followPostButtonText = found ? "Unfollow Post" : "Follow Post"
          self.followPostButton.setTitle(followPostButtonText, for: .normal)
        }
      }
    }
    
    func presentCommentAlertController() {
      let alertController = UIAlertController(title: "Add a Comment", message: "", preferredStyle: .alert)
      alertController.addTextField { (textField) in
        textField.placeholder = "Start typing comment..."
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      let commentAction = UIAlertAction(title: "Comment", style: .default) { (_) in
        guard let commentText = alertController.textFields?.first?.text,
          !commentText.isEmpty,
          let post = self.post else { return }
        PostController.shared.addComment(text: commentText, post: post, completion: { (comment) in
        })
        self.tableView.reloadData()
      }
      alertController.addAction(cancelAction)
      alertController.addAction(commentAction)
      self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)

        let comment = post?.comments[indexPath.row]
        
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = comment?.timestamp.formatToString()

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
