//
//  ViewController.swift
//  rick and morty
//
//  Created by user on 22.07.2024.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    // MARK : - Public Propirties
    
    
    // MARK : - Private Properties
    
    private lazy var mainView = {
        let view = UIView ()
        return view
    }()
    
    // MARK: - Initializers
    
    init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .black
    }
}

