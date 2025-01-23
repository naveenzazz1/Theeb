//
//  NotificationsHistoryVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 01/01/2024.
//

import UIKit

class NotificationsHistoryVC: BaseViewController {

    @IBOutlet weak var tableViewNotifications: UITableView!
    
    // Empty state label
    var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have notifications"
        label.textAlignment = .center
        label.textColor = UIColor.theebPrimaryColor
        label.font = UIFont.BahijTheSansArabicSemiBold(fontSize: 20)
        label.numberOfLines = 0
        label.isHidden = true // Initially hidden
        return label
    }()
    
    var notitficationsArr = [Messages]() {
        didSet {
            tableViewNotifications.reloadData()
            showEmptyStateIfNeeded() // Call showEmptyStateIfNeeded after updating the array
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        handleViews()
        getNotifications()
    }
    
    func getNotifications() {
        CustomLoader.customLoaderObj.startAnimating()
        PushNotificationService.instance.getPushNotificationAccesToken { success, token in
            if success, let token = token {
                PushNotificationService.instance.getNotificationHistory(accessToken: token) { [weak self] notification in
                    self?.notitficationsArr = notification?.messages ?? [Messages]()
                    CustomLoader.customLoaderObj.stopAnimating()
                    self?.showEmptyStateIfNeeded()
                }
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(title: "" ,message: "error_Occured_msg".localized) { (index, title) in
                     print(index, title)
                }
                CustomLoader.customLoaderObj.stopAnimating()
            }
        }
    }
    
    func setupNavigationBar() {
        title = "landing_page_Notifications".localized
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem?.tintColor = UIColor.theebSecondaryColor
    }
    
    func handleViews() {
        tableViewNotifications.delegate = self
        tableViewNotifications.dataSource = self
        let albumNib = UINib(nibName: NotificationHistroryCell.identifier, bundle: nil)
        tableViewNotifications.register(albumNib, forCellReuseIdentifier: NotificationHistroryCell.identifier)
        tableViewNotifications.tableFooterView = UIView()
        
        // Add empty state label to the view and center it
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Show empty state only after the API call returns and the array is empty
    func showEmptyStateIfNeeded() {
        if notitficationsArr.isEmpty {
            emptyStateLabel.isHidden = false
            tableViewNotifications.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            tableViewNotifications.isHidden = false
        }
    }

    class func initializeFromStoryboard() -> NotificationsHistoryVC {
        let storyboard = UIStoryboard(name: StoryBoards.Home, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: NotificationsHistoryVC.self)) as! NotificationsHistoryVC
    }
    
    @objc func btnClearPressed(_ sender: UIButton) {
        CachingManager.notificationsTitleAndBody = nil
        notitficationsArr.removeAll()
    }
}

extension NotificationsHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notitficationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: NotificationHistroryCell.identifier, for: indexPath) as? NotificationHistroryCell else { return UITableViewCell() }
        cell.setup(notification: notitficationsArr[indexPath.row])
        return cell
    }
}
