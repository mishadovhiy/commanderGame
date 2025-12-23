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
        view.backgroundColor = .clear
        delegate = self
        dataSource = self
        setViewControllers([
            LevelViewController.initiate(
                data: pageData.first!)
        ], direction: .forward, animated: true)
        view.addSubview(DestinationOutMaskedView(type: .borders))
    }
    
    var parentVC: LevelListSuperViewController? {
        parent as? LevelListSuperViewController
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
        let page = pageViewController.viewControllers?.first?.view.tag ?? 1
        print("willTransitionTowillTransitionTo ", page)
        parentVC?.selectedLevel = .init(levelPage: "\(page)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = pageViewController.viewControllers?.first?.view.tag ?? 0
        print("dfsdasdfd completed", completed, " finished ", finished, "indexx", index)
        if finished {
            parentVC?.selectedLevel = .init(levelPage: "\(index + 1)")
            parentVC?.homeParentVC?.setMap(for: pageData[index])
        }
//        if !completed {
//            return
//        }
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
