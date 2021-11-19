//
//  MyPageViewController.swift
//  SkincareApp
//
//  Created by Anna on 10/28/21.
//

import UIKit

class MyPageViewController: UIPageViewController {
    
    fileprivate var items: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = nil
        decoratePageControl()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [MyPageViewController.self])
        pc.currentPageIndicatorTintColor = .orange
        pc.pageIndicatorTintColor = .gray
    }
    
    func populateItems(images: [UIImage]) {
        
        for img in images {
            let c = createCarouselItemControler(image: img)
            self.items.append(c)
        }
        if items.count > 0 {
            setViewControllers([items.first!], direction: .forward, animated: true) { done in
            if done {
                self.dataSource = self
            }
        }
        }
        
        //        reloadInputViews()
        //        viewDidLayoutSubviews()
        
    }
    
    fileprivate func createCarouselItemControler(with titleText: String?="", with color: UIColor? = .clear,image: UIImage?) -> UIViewController {
        let c = UIViewController()
        c.view = CarouselItem(titleText: titleText, background: color,image: image, frame: self.view.bounds)
        
        return c
    }
}

extension MyPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
//    // Returns the number of items to be reflected in the page indicator.
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return items.count
//    }
//    
//    // Returns the index of the selected item to be reflected in the page indicator.
//    func presentationIndex(for _: UIPageViewController) -> Int {
//        guard let firstViewController = items.first,
//              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
//            return 0
//        }
//        
//        return firstViewControllerIndex
//    }
    
    
}
