//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var selectImageButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectImageButton.setTitle("Select Image", for: .normal)
        postImageView.image = nil
        captionTextField.text = ""
    }
    
    // MARK: - Actions
    
    @IBAction func addPostPressed(_ sender: Any) {
        guard let image = postImageView.image, let caption = captionTextField.text, !caption.isEmpty else { return }
        
        PostController.shared.createPostWith(image: image, caption: caption) { (_) in
            
        }
        // Goes back to the post list view
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
        selectImageButton.setTitle("", for: .normal)
        
        presentImageAlertController()
//        let image = UIImage(named: "sun")
//        postImageView.image = image
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Private functions
    
    private func presentImageAlertController() {
        let alertController = UIAlertController(title: "Add an image", message: "Where do you want to add an image from?", preferredStyle: .alert)
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
          
          
        }
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

}
