// ProfileFieldsViewCell.swift

import UIKit

/// Ячейка с кнопками дополнительных опций
final class ProfileFieldsViewCell: UITableViewCell {
    // MARK: - Constants

    static let identifier = "ProfileButtonViewCell"

    // MARK: - Visual Components

    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageBackground: UIView = {
        let imageBackground = UIView()
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.backgroundColor = UIColor(named: ColorPalette.backgroundTeal.rawValue)
        imageBackground.layer.cornerRadius = 12
        return imageBackground
    }()

    private let lineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor(named: ColorPalette.deviderLight.rawValue)
        return lineView
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: ColorPalette.dirtyGreen.rawValue)
        label.font = .verdana(ofSize: 18)
        return label
    }()

    private let goToImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: ImageName.goToIcon.rawValue)
        return imageView
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private Properties

    private var buttonHandler: VoidHandler?

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

    // MARK: - Public Properties

    func setButtonInformation(text: String, icon: UIImage, handler: @escaping VoidHandler) {
        buttonLabel.text = text
        buttonImageView.image = icon
        buttonHandler = handler
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    // MARK: - Private Methods

    private func createView() {
        contentView.backgroundColor = .white
        contentView.addSubview(button)
        button.addSubview(imageBackground)
        imageBackground.addSubview(buttonImageView)
        button.addSubview(buttonLabel)
        button.addSubview(lineView)
        button.addSubview(goToImageView)
    }

    private func setConstraints() {
        setButtonConstraints()
        setImageBackgroundConstraints()
        setButtonImageViewConstraints()
        setButtonLabelConstrains()
        setLineViewConstrains()
        setGoToImageViewConstraints()
    }

    private func setButtonConstraints() {
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 67).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func setImageBackgroundConstraints() {
        imageBackground.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 25).isActive = true
        imageBackground.topAnchor.constraint(equalTo: button.topAnchor, constant: 15).isActive = true
        imageBackground.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageBackground.widthAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func setButtonImageViewConstraints() {
        buttonImageView.leadingAnchor.constraint(equalTo: imageBackground.leadingAnchor, constant: 10).isActive = true
        buttonImageView.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: 10).isActive = true
        buttonImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        buttonImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
    }

    private func setButtonLabelConstrains() {
        buttonLabel.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor).isActive = true
        buttonLabel.leadingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: 16).isActive = true
        buttonLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        buttonLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -75).isActive = true
    }

    private func setLineViewConstrains() {
        lineView.bottomAnchor.constraint(equalTo: imageBackground.bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: 16).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -52).isActive = true
    }

    private func setGoToImageViewConstraints() {
        goToImageView.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor).isActive = true
        goToImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -25).isActive = true
        goToImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        goToImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }

    @objc private func buttonAction() {
        buttonHandler?()
    }
}
