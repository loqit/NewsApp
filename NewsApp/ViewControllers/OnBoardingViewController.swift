//
//  OnBoardingViewController.swift
//  NewsApp
//
//  Created by Андрей Бобр on 30.01.21.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let titles = ["News", "Search", "Bookmarks"]
    private let rootVC = RootViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    func configure() {
        // Set up scroll view
        let rootFrame = rootVC.view.frame.size
        scrollView.frame = rootVC.view.bounds
        //scrollView.backgroundColor = .red
        view.addSubview(scrollView)
        
        
        for x in 0..<titles.count {
            
            let xPos = CGFloat(x) * rootFrame.width
            let pageView = UIView(frame: CGRect(x: xPos, y: 0, width: rootFrame.width, height: rootFrame.height))
           // pageView.backgroundColor = .green
            scrollView.addSubview(pageView)
            
            
            // Attributes
            
            let lable = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.width - 20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 20, y: 140, width: pageView.frame.width - 20, height: 320))
            let nextButton = UIButton(frame: CGRect(x: pageView.frame.width - 65, y: pageView.frame.height - 100, width: 40, height: 50))
          //  let perviousButton = UIButton(frame: CGRect(x: 30, y: pageView.frame.height - 20, width: 40, height: 50))
            
            // Configure lable
            lable.textAlignment = .center
            lable.font = UIFont(name: "Helvetica-Bold", size: 32)
            pageView.addSubview(lable)
            lable.text = titles[x]
            
            // Configure imageView
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "welcome_\(x + 1)")
            print(x + 1)
            pageView.addSubview(imageView)
            
            // Configure nextButton
            nextButton.tag = x + 1
            nextButton.setTitleColor(.black, for: .normal)
            nextButton.backgroundColor = .clear
            nextButton.setTitle("Next", for: .normal)
            if x == titles.count - 1 {
                nextButton.frame = CGRect(x: pageView.frame.width - 105, y: pageView.frame.height - 100, width: 100, height: 50)
                nextButton.setTitle("Get started", for: .normal)
            }
            nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
            pageView.addSubview(nextButton)
        }
        scrollView.contentSize = CGSize(width: Int(rootFrame.width) * titles.count, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    @objc
    func nextButtonTapped(_ button: UIButton) {
        guard button.tag < titles.count else {
            dismiss(animated: true)
            return
        }
        scrollView.setContentOffset(CGPoint(x: rootVC.view.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }

}

