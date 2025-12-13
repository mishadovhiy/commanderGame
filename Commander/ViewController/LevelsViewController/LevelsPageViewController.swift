//
//  LevelsPageViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelsPageViewController: UIPageViewController {

    let pageData: [LevelsListBuilderModel] = .allData
    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([LevelViewController.initiate(data: pageData.first!)], direction: .forward, animated: true)
    }
    
}

extension LevelsPageViewController {
    static func initiate() -> Self {
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(
                withIdentifier: .init(
                    describing: Self.self
                )
            ) as! Self
    }
}

extension LevelsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        index = previousViewControllers.count
        print(index, " gyhukijk ")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if index == 0 {
            return nil
        }
        return LevelViewController
            .initiate(data: pageData[index - 1])

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if pageData.count - 1 >= index {
            print(index, " jvbukhinj")
            return LevelViewController
                .initiate(data: pageData[index + 1])
        }
        return nil
    }
    
    
}
