//
//  SettingsViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 14/02/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = 32
        
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 970)
    }
    
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
