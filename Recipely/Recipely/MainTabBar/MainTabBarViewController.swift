// MainTabBarViewController.swift

import UIKit

/// Протокол экрана рецептов
protocol MainTabBarViewProtocol: AnyObject {}

/// Вью главного таб бара
final class MainTabBarViewController: UITabBarController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: - Private Methods

    private func setupTabBar() {
        tabBar.tintColor = UIColor(named: ColorPalette.selectedTitle.rawValue)
        tabBar.unselectedItemTintColor = UIColor(named: ColorPalette.dirtyGreen.rawValue)
        tabBar.backgroundColor = .white
    }
}

/// MainTabBarViewController + MainTabBarViewProtocol
extension MainTabBarViewController: MainTabBarViewProtocol {}
