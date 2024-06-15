// ProfileViewController.swift

import UIKit

/// Протокол экрана профиля
protocol ProfileViewProtocol: AnyObject {
    /// Презентер экрана
    var presenter: ProfileViewPresenterProtocol? { get set }
    /// Показ алерта с полем для измененеия имени
    func showChangeNameAlert()
    /// Показ алерта с сообщением о подтверждении выхода с аккаунта
    func showLogOutAlert()
    /// Установка нового имени из источника данных
    func setNewNameFromSource()
    /// Показ вью с информацией прайвеси
    func showPrivacyCard(privacyText: String)
    /// Обновление данных
    func reloadTableView()
}

/// Экран профиля
final class ProfileViewController: UIViewController {
    // MARK: - Visual Components

    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = Local.ProfileViewController.viewTitleText
        label.font = .verdanaBold(ofSize: 28)
        return label
    }()

    private lazy var backgroundView = UIView(frame: view.frame)

    private let tableView = UITableView()

    // MARK: - Public Properties

    var presenter: ProfileViewPresenterProtocol?

    // MARK: - Private Properties

    private let contentTypes: [ContentTypes] = [.userInfo, .profileButtons]
    private let fields: [FieldsType] = [.bonuses, .termsAndPrivacy, .logOut]
    private let imagePicker = ImagePicker()
    private lazy var changePhotoHandler = { [weak self] in
        guard let self = self else { return }
        self.imagePicker.showImagePicker(in: self) { [weak self] image in
            guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
            self?.presenter?.actionChangePhoto(imageData: imageData)
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLogs()
    }

    // MARK: - Private Methods

    private func configureView() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileLabel)
    }

    private func setNewName(_ newName: String) {
        presenter?.editNameSurname(name: newName)
    }

    private func configureTableView() {
        tableView.register(UserInfoViewCell.self, forCellReuseIdentifier: UserInfoViewCell.identifier)
        tableView.register(
            ProfileFieldsViewCell.self,
            forCellReuseIdentifier: ProfileFieldsViewCell.identifier
        )
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.accessibilityIdentifier = Local.ProfileTableView.accessibilityIdentifier
    }

    private func showBonuses() {
        presenter?.showBonuses()
    }

    private func showTermsAndPrivacy() {
        presenter?.openPrivacyInfo()
    }

    private func showLogOutAllert() {
        presenter?.logOutAction()
    }

    private func showAlert(title: String, buttonAgreeTitle: String, handler: VoidHandler?) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let actionClose = UIAlertAction(title: Local.ProfileViewController.closeButtonText, style: .default)
        let actionYes = UIAlertAction(title: buttonAgreeTitle, style: .default) { _ in
            handler?()
        }
        alertController.addAction(actionClose)
        alertController.addAction(actionYes)
        present(alertController, animated: true)
    }

    private func addLogs() {
        presenter?.sendLog()
    }
}

// MARK: - ProfileViewController + ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func showLogOutAlert() {
        showAlert(
            title: Local.ProfileViewController.alertTitle,
            buttonAgreeTitle: Local.ProfileViewController.yesButtonText
        ) { [weak self] in
            self?.presenter?.logOut()
        }
    }

    func showChangeNameAlert() {
        let alertView = UIAlertController(
            title: Local.ProfileViewController.alertText,
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: Local.ProfileViewController.cancelButtonText, style: .cancel)
        let okAction = UIAlertAction(
            title: Local.ProfileViewController.okButtonText,
            style: .default
        ) { [weak self] _ in
            self?.setNewName(alertView.textFields?.first?.text ?? "")
        }
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        alertView.addTextField()
        alertView.textFields?.first?.placeholder = Local.ProfileViewController.nameSurname
        present(alertView, animated: true)
    }

    func setNewNameFromSource() {
        tableView.reloadData()
    }

    func showPrivacyCard(privacyText: String) {
        backgroundView.backgroundColor = UIColor(white: 0.2, alpha: 0.0)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let privacyView = PrivacyView(frame: CGRect(origin: CGPoint(x: 0, y: view.frame.height), size: view.frame.size))
        privacyView.set(privacyText: privacyText) { [weak self] in
            Timer.scheduledTimer(
                timeInterval: 0.3,
                target: self ?? UIViewController(),
                selector: #selector(self?.closePrivacy),
                userInfo: nil,
                repeats: false
            )
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.backgroundView.backgroundColor = UIColor(white: 0.2, alpha: 0)
            }
        }

        backgroundView.addSubview(privacyView)
        windowScene?.windows.last?.addSubview(backgroundView)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backgroundView.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
            privacyView.frame.origin.y = (self?.view.frame.height ?? 0) / 2
        }
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    @objc private func closePrivacy() {
        backgroundView.removeFromSuperview()
    }
}

// MARK: - Добавление групп контента и вида кнопок на экране профиля

extension ProfileViewController {
    enum ContentTypes {
        /// Информация о пользователе
        case userInfo
        /// Кнопки с дополнительными возможностями
        case profileButtons
    }

    enum FieldsType {
        /// Кнопка бонусов
        case bonuses
        /// Кнопка условия эксплуатации
        case termsAndPrivacy
        /// Кнопка показа партнеров
        case logOut
    }
}

// MARK: - ProfileViewController + UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        contentTypes.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentTypes[section] {
        case .userInfo:
            return 1
        case .profileButtons:
            return fields.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentTypes[indexPath.section] {
        case .userInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UserInfoViewCell.identifier,
                for: indexPath
            ) as? UserInfoViewCell else { return UITableViewCell() }

            switch presenter?.getUserInformation() {
            case let .data(userInfo):
                tableView.isScrollEnabled = true
                tableView.allowsSelection = true
                cell.setUserInformation(userInfo, changePhotoComplition: changePhotoHandler) { [weak self] in
                    self?.presenter?.actionChangeName()
                }
            case .noData:
                tableView.isScrollEnabled = true
                tableView.allowsSelection = true
                cell.setUserInformation(UserInfo(), changePhotoComplition: changePhotoHandler) { [weak self] in
                    self?.presenter?.actionChangeName()
                }
            default:
                tableView.isScrollEnabled = false
                tableView.allowsSelection = false
                cell.setUserInformation(nil, changePhotoComplition: changePhotoHandler) { [weak self] in
                    self?.presenter?.actionChangeName()
                }
            }
            return cell

        case .profileButtons:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileFieldsViewCell.identifier,
                for: indexPath
            ) as? ProfileFieldsViewCell else { return UITableViewCell() }

            switch fields[indexPath.row] {
            case .bonuses:
                cell
                    .setButtonInformation(
                        text: Local.ProfileViewController.bonusesButtonText,
                        icon: UIImage(named: ImageName.starIcon.rawValue) ?? UIImage()
                    ) { [weak self] in
                        self?.showBonuses()
                    }
            case .termsAndPrivacy:
                cell.setButtonInformation(
                    text: Local.ProfileViewController.termsAndPrivacyButtonText,
                    icon: UIImage(named: ImageName.sheetIcon.rawValue) ?? UIImage()
                ) { [weak self] in
                    self?.showTermsAndPrivacy()
                }
            case .logOut:
                cell
                    .setButtonInformation(
                        text: Local.ProfileViewController.logOutButtonText,
                        icon: UIImage(named: ImageName.shareIcon.rawValue) ?? UIImage()
                    ) { [weak self] in
                        self?.showLogOutAllert()
                    }
            }
            return cell
        }
    }
}
