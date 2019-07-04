//
//  DetailViewController.swift
//  LanguageExample
//
//  Created by Bassem Abbas on 7/4/19.
//  Copyright © 2019 Bassem Abbas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

	@IBOutlet weak var detailDescriptionLabel: UILabel!


	func configureView() {
		// Update the user interface for the detail item.
		if let detail = detailItem {
		    if let label = detailDescriptionLabel {
		        label.text = detail.description
		    }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		configureView()
	}

	@IBAction func buttondidTapped(_ sender: Any) {

		var imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .camera;
		imagePicker.allowsEditing = false
		self.present(imagePicker, animated: true, completion: nil)

	}
	
	var detailItem: NSDate? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}


}

