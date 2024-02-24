//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Арина Колганова on 18.02.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    private let onSuccess: (() -> Void)?

    private lazy var pages: [BaseViewController<OnboardingViewImp>] = {
        let firstPage = BaseViewController<OnboardingViewImp>()
        firstPage.rootView.parameter = .first
        firstPage.rootView.delegate = self
        firstPage.rootView.setView()

        let secondPage = BaseViewController<OnboardingViewImp>()
        secondPage.rootView.parameter = .second
        secondPage.rootView.delegate = self
        secondPage.rootView.setView()

        return [firstPage, secondPage]
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .trackerBlack
        pageControl.pageIndicatorTintColor = .trackerBlack.withAlphaComponent(0.3)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    init(onSuccess: (() -> Void)?) {
        self.onSuccess = onSuccess

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! BaseViewController<OnboardingViewImp>) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return pages.last
        }

        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! BaseViewController<OnboardingViewImp>) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return pages.first
        }

        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController as! BaseViewController<OnboardingViewImp>) {
            pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    func openTracker() {
        onSuccess?()
    }
}
