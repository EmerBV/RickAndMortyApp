//
//  APPTabBarViewController.swift.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

final class APPTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }

    private func setUpTabs() {
        let charactersVC = APPCharacterViewController()
        let locationsVC = APPLocationViewController()
        let episodesVC = APPEpisodeViewController()
        let settingsVC = APPSettingsViewController()

        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic

        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationsVC)
        let nav3 = UINavigationController(rootViewController: episodesVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)

        nav1.tabBarItem = UITabBarItem(title: "Characters",
                                       image: UIImage(named: "rick-sanchez"),
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations",
                                       image: UIImage(named: "location"),
                                       tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes",
                                       image: UIImage(named: "episodes"),
                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: UIImage(named: "settings-gear"),
                                       tag: 4)
        tabBar.tintColor = .label

        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
            nav.navigationBar.tintColor = .label
        }

        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true
        )
    }
}
