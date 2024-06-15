// UserInfoViewCell.swift

import UIKit

/// Ячейка с информацией о пользователе
final class UserInfoViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let profilePhotoHeigh: CGFloat = 160
    }

    static let identifier = "UserInfoViewCell"

    // MARK: - Visual Components

    private let profilePhotoButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.profilePhotoHeigh / 2
        button.layer.borderWidth = 3
        button.clipsToBounds = true
        button.layer.borderColor = UIColor(named: ColorPalette.selectedTitle.rawValue)?.cgColor
        return button
    }()

    private let nameView: UIView = {
        let nameView = UIView()
        nameView.translatesAutoresizingMaskIntoConstraints = false
        return nameView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(named: ColorPalette.dirtyGreen.rawValue)
        label.font = .verdanaBold(ofSize: 25)
        return label
    }()

    private let changeNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ImageName.pencil.rawValue), for: .normal)
        button.accessibilityIdentifier = Local.Profile.ChangeNameButton.accessibilityIdentifier
        return button
    }()

    // MARK: - Private Properties

    private var isShimming = true
    private var buttonChangeHandler: VoidHandler?
    private var buttonChangePhotoHandler: VoidHandler?

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
        setConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isShimming {
            profilePhotoButton.startShimmeringAnimation()
            nameView.startShimmeringAnimation()
        }
        fullNameLabel.isHidden = isShimming
        changeNameButton.isHidden = isShimming
    }

    // MARK: - Public Methods

    func setUserInformation(
        _ userInfo: UserInfo?,
        changePhotoComplition: @escaping VoidHandler,
        changeNameComplition: @escaping VoidHandler
    ) {
        if let userInfo = userInfo {
            isShimming = false
            profilePhotoButton.stopShimmeringAnimation()
            nameView.stopShimmeringAnimation()
            profilePhotoButton.setImage(UIImage(data: userInfo.userImageData), for: .normal)
            fullNameLabel.text = "\(userInfo.nameSurname)"
        } else {
            isShimming = true
        }
        buttonChangeHandler = changeNameComplition
        buttonChangePhotoHandler = changePhotoComplition
    }

    // MARK: - Private Methods

    private func createView() {
        contentView.backgroundColor = .white
        contentView.addSubview(profilePhotoButton)
        nameView.addSubview(fullNameLabel)
        nameView.addSubview(changeNameButton)
        contentView.addSubview(nameView)
        changeNameButton.addTarget(self, action: #selector(changeNameTapped), for: .touchUpInside)
        profilePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        profilePhotoButton.imageView?.clipsToBounds = true
        profilePhotoButton.imageView?.contentMode = .scaleAspectFill
    }

    private func setConstraints() {
        setProfilePhotoImageViewConstraints()
        setfullNameLabelConstraints()
        setChangeNameButtonConstraints()
        setNameViewConstraints()
    }

    private func setProfilePhotoImageViewConstraints() {
        profilePhotoButton.heightAnchor.constraint(equalToConstant: Constants.profilePhotoHeigh).isActive = true
        profilePhotoButton.widthAnchor.constraint(equalToConstant: Constants.profilePhotoHeigh).isActive = true
        profilePhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profilePhotoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36).isActive = true
    }

    private func setfullNameLabelConstraints() {
        fullNameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: nameView.topAnchor).isActive = true
        fullNameLabel.bottomAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
        fullNameLabel.trailingAnchor.constraint(equalTo: changeNameButton.leadingAnchor, constant: -8).isActive = true
    }

    private func setChangeNameButtonConstraints() {
        changeNameButton.trailingAnchor.constraint(equalTo: nameView.trailingAnchor).isActive = true
        changeNameButton.topAnchor.constraint(equalTo: nameView.topAnchor).isActive = true
        changeNameButton.bottomAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
        changeNameButton.widthAnchor.constraint(equalTo: changeNameButton.widthAnchor).isActive = true
    }

    private func setNameViewConstraints() {
        nameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.profilePhotoHeigh).isActive = true
        nameView.topAnchor.constraint(equalTo: profilePhotoButton.bottomAnchor, constant: 26).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -29).isActive = true
    }

    @objc private func changeNameTapped() {
        buttonChangeHandler?()
    }

    @objc private func changePhotoTapped() {
        buttonChangePhotoHandler?()
    }
}
