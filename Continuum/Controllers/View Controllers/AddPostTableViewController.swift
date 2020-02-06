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
    
    @IBOutlet weak var captionTextField: UITextField!
    
    // MARK: - Properties
    
    var selectedImage: UIImage?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = ""
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectorVC" {
            let photoSelector = segue.destination as? PhotoSelectorViewController
            photoSelector?.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addPostPressed(_ sender: Any) {
        guard let image = selectedImage, let caption = captionTextField.text, !caption.isEmpty else { return }
        
        PostController.shared.createPostWith(image: image, caption: caption) { (_) in
            
        }
        // Goes back to the post list view
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}
