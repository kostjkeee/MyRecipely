// ProfileBonusesViewController.swift

import UIKit

/// Протокол экрана бонусов
protocol ProfileBonusesViewProtocol: AnyObject {
    ///  Презентер экрана
    var presenter: ProfileBonusesPresenter? { get set }
    /// Установка значения количетсва бонусов
    func setBonuses(bonusesCount: Int)
}

/// Экран бонусов пользователя
final class ProfileBonusesViewController: UIViewController {
    // MARK: - Visual Components

    private let yourBonusesLabel: UILabel = {
        let label = UILabel()
        label.text = Local.ProfileBonusesViewController.bonusesText
        label.font = .verdanaBold(ofSize: 20)
        label.textColor = UIColor(named: ColorPalette.dirtyGreen.rawValue)
        label.textAlignment = .center
        return label
    }()

    private var bonusesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 30)
        label.textColor = UIColor(named: ColorPalette.dirtyGreen.rawValue)
        label.textAlignment = .left
        return label
    }()

    private let bonusesBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.bonusesBox.rawValue)
        return imageView
    }()

    private let bonusesStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.bonusesStar.rawValue)
        return imageView
    }()

    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageName.dismissButton.rawValue), for: .normal)
        button.accessibilityIdentifier = Local.Profile.BonusesView.DismissButton.accessibilityIdentifier
        return button
    }()

    // MARK: - Public Properties

    var presenter: ProfileBonusesPresenter?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(yourBonusesLabel)
        view.addSubview(bonusesCountLabel)
        view.addSubview(bonusesBoxImageView)
        view.addSubview(bonusesStarImageView)
        view.addSubview(dismissButton)
    }

    private func setupConstraints() {
        makeTapDismissButton()
        makeBonusesLabelConstraints()
        makeBonusesBoxImageViewConstraints()
        makeBonusesStarImageViewConstraints()
        makeBonusesCountLabelConstraints()
        makeDismissButtonConstraints()
    }

    private func makeTapDismissButton() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }

    private func makeBonusesLabelConstraints() {
        yourBonusesLabel.translatesAutoresizingMaskIntoConstraints = false
        yourBonusesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        yourBonusesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        yourBonusesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 46).isActive = true
        yourBonusesLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }

    private func makeBonusesBoxImageViewConstraints() {
        bonusesBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        bonusesBoxImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120).isActive = true
        bonusesBoxImageView.topAnchor.constraint(equalTo: yourBonusesLabel.bottomAnchor, constant: 13).isActive = true
        bonusesBoxImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bonusesBoxImageView.heightAnchor.constraint(equalToConstant: 136).isActive = true
    }

    private func makeBonusesStarImageViewConstraints() {
        bonusesStarImageView.translatesAutoresizingMaskIntoConstraints = false
        bonusesStarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 144).isActive = true
        bonusesStarImageView.topAnchor.constraint(equalTo: bonusesBoxImageView.bottomAnchor, constant: 31)
            .isActive = true
        bonusesStarImageView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        bonusesStarImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }

    private func makeBonusesCountLabelConstraints() {
        bonusesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        bonusesCountLabel.leadingAnchor.constraint(equalTo: bonusesStarImageView.trailingAnchor, constant: 11)
            .isActive = true
        bonusesCountLabel.topAnchor.constraint(equalTo: bonusesBoxImageView.bottomAnchor, constant: 28).isActive = true
        bonusesCountLabel.widthAnchor.constraint(equalToConstant: 177).isActive = true
        bonusesCountLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    private func makeDismissButtonConstraints() {
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 13).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }

    @objc private func dismissButtonTapped() {
        presenter?.close()
    }
}

// MARK: - ProfileBonusesViewController + ProfileBonusesViewProtocol

extension ProfileBonusesViewController: ProfileBonusesViewProtocol {
    func setBonuses(bonusesCount: Int) {
        bonusesCountLabel.text = String(bonusesCount)
    }
}
