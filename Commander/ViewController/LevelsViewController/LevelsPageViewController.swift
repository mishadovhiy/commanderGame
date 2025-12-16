//
//  LevelsPageViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelsPageViewController: UIPageViewController {

    let pageData: [LevelPagesBuilder] = .allData
    private var index: Int = 0
    private var previousIndex: Int = 0
    
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
        (self.parent as? LevelListSuperViewController)?.selectedLevel = .init()
        print("didSetNil")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            self.index = previousIndex
            return
        }
        if finished {
            previousIndex = index
            (self.parent as? LevelListSuperViewController)!.selectedLevel = .init(levelPage: "\(index + 1)")
        }
//        let vc = previousViewControllers.first as? LevelViewController
//        self.index = vc?.i ?? 0
//        print(vc?.i, " gyhukijk ")
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if index == 0 {
            return nil
        }
        self.previousIndex = index
        self.index -= 1
        return LevelViewController
            .initiate(data: pageData[index])

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if pageData.count - 1 >= index + 1 {
            print(index, " jvbukhinj")
            self.previousIndex = index
            self.index += 1
            return LevelViewController
                .initiate(data: pageData[index])
        }
        return nil
    }
    
    
}
