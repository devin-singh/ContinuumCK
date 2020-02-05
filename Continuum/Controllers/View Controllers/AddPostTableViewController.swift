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
        let image = UIImage(named: "sun")
        postImageView.image = image
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    

}
