// RecipeErrorCell.swift

import UIKit

/// Ячейка ошибки загрузки данных для рецепта
final class RecipeErrorCell: UITableViewCell {
    // MARK: - Constants

    static let identifier = "RecipeErrorCell"

    // MARK: - Visual Components

    private let backgroundLightningView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorPalette.deviderLight.rawValue)
        view.layer.cornerRadius = 12
        return view
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.textColor = UIColor(named: ColorPalette.lightInfoText.rawValue)
        label.text = Local.RecipeErrorCell.noDataText
        label.textAlignment = .center
        return label
    }()

    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle(Local.RecipeErrorCell.reloadButtonText, for: .normal)
        button.titleLabel?.font = .verdana(ofSize: 14)
        button.setTitleColor(UIColor(named: ColorPalette.lightInfoText.rawValue), for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(named: ColorPalette.deviderLight.rawValue)
        button.setImage(UIImage(named: ImageName.reload.rawValue), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        return button
    }()

    private let errorView = UIView()

    private let errorImageView = UIImageView(image: UIImage(named: ImageName.lightning.rawValue))

    // MARK: - Public Properties

    var reloadDataHandler: VoidHandler?

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

    // MARK: - Private Methods

    private func createView() {
        contentView.addSubview(errorView)
        errorView.isHidden = false
        errorView.addSubview(backgroundLightningView)
        backgroundLightningView.addSubview(errorImageView)
        errorView.addSubview(errorLabel)
        errorView.addSubview(reloadButton)
    }

    private func setConstraints() {
        createErrorViewConstraints()
        createBackgroundLightningViewConstraints()
        createErrorImageViewConstraints()
        createErrorLabelConstraints()
        createReloadButtonConstraints()
    }

    private func createErrorViewConstraints() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        errorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -250).isActive = true
        errorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        errorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
    }

    private func createBackgroundLightningViewConstraints() {
        backgroundLightningView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLightningView.topAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
        backgroundLightningView.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        backgroundLightningView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backgroundLightningView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func createErrorImageViewConstraints() {
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorImageView.centerYAnchor.constraint(equalTo: backgroundLightningView.centerYAnchor).isActive = true
        errorImageView.centerXAnchor.constraint(equalTo: backgroundLightningView.centerXAnchor).isActive = true
        errorImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        errorImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }

    private func createErrorLabelConstraints() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: backgroundLightningView.bottomAnchor, constant: 17).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: errorView.widthAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }

    private func createReloadButtonConstraints() {
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 25).isActive = true
        reloadButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reloadButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    @objc private func reloadData() {
        reloadDataHandler?()
    }
}
