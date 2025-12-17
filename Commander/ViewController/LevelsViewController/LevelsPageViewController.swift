//
//  LevelsPageViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelsPageViewController: UIPageViewController {

    let pageData: [LevelPagesBuilder] = .allData
    
    override func loadView() {
        super.loadView()
        delegate = self
        dataSource = self
        setViewControllers([
            LevelViewController.initiate(
                data: pageData.first!)
        ], direction: .forward, animated: true)
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
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        (self.parent as? LevelListSuperViewController)?.selectedLevel = .init(levelPage: "\(pageViewController.viewControllers?.first?.view.tag ?? 1)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = pageViewController.viewControllers?.first?.view.tag ?? 0
        if !completed {
            return
        }
        if finished {
            (self.parent as? LevelListSuperViewController)!.selectedLevel = .init(levelPage: "\(index + 1)")
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        if index == 0 {
            return nil
        }
        let vc = LevelViewController
            .initiate(data: pageData[index - 1])
        vc.view.tag = index - 1
        return vc

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag

        if pageData.count - 1 >= index + 1 {
            let vc = LevelViewController
                .initiate(data: pageData[index + 1])
            vc.view.tag = index + 1
            return vc
        }
        return nil
    }
    
    
}
