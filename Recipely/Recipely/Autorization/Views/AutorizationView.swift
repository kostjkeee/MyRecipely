// AutorizationView.swift

import AutorizationFieldLibrary
import UIKit

/// Протокол экрана авторизации
protocol AutorizationViewProtocol: AnyObject {
    ///  Презентер экрана
    var presenter: AutorizationViewPresenterProtocol? { get set }
    /// Функция изменения текущего отображения пароля
    func changePasswordvisableState(isVisable: Bool)
}

/// Экран входа
final class AutorizationViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        static let emailTextFieldTag = 0
        static let passwordTextFieldTag = 1
    }

    // MARK: - Visual components

    private let gradientLayer = CAGradientLayer()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AutorizationView.loginText
        label.textColor = UIColor(named: ColorPalette.loginText.rawValue)
        label.font = .verdanaBold(ofSize: 28)
        label.textAlignment = .left
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AutorizationView.emailText
        label.textColor = UIColor(named: ColorPalette.loginText.rawValue)
        label.font = .verdanaBold(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AutorizationView.passwordText
        label.textColor = UIColor(named: ColorPalette.loginText.rawValue)
        label.font = .verdanaBold(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let emailTextField = AutorizationField(
        tag: Constants.emailTextFieldTag,
        placeholderType: .emailAddress,
        viewMode: .whileEditing
    )

    private let emailLeftView: UIView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 24, height: 24))
        imageView.image = UIImage(named: ImageName.email.rawValue)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        leftView.addSubview(imageView)
        return leftView
    }()

    private let emailRightView: UIView = {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 24, height: 24))
        imageView.image = UIImage(named: ImageName.cancel.rawValue)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        rightView.addSubview(imageView)
        return rightView
    }()

    private let passwordTextField = AutorizationField(tag: Constants.passwordTextFieldTag)

    private let passwordLeftView: UIView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 24, height: 24))
        imageView.image = UIImage(named: ImageName.lockIcon.rawValue)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        leftView.addSubview(imageView)
        return leftView
    }()

    private let passwordHideButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        button.setImage(UIImage(named: ImageName.unvisibility.rawValue), for: .normal)
        return button
    }()

    private lazy var passwordRightView: UIView = {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        return rightView
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Local.AutorizationView.loginText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: ColorPalette.loginButtons.rawValue)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private let incorrectPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AutorizationView.incorrectPassword
        label.textColor = .red
        label.font = .verdanaBold(ofSize: 12)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()

    private let incorrectEmailLabel: UILabel = {
        let label = UILabel()
        label.text = Local.AutorizationView.incorrectEmail
        label.textColor = .red
        label.font = .verdanaBold(ofSize: 12)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private lazy var errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorPalette.redError.rawValue)
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .verdana(ofSize: 18)
        label.text = Local.AutorizationView.errorLoginText
        return label
    }()

    // MARK: - Public Properties

    var presenter: AutorizationViewPresenterProtocol?

    // MARK: - Private Properties

    private let validityTypes: [ValidityType] = [.email, .password]
    private lazy var loginButtonBottomConstraint = loginButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -71
    )
    private lazy var errorWiewConstraint = errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 87)

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        okButton()
        addGradientLayer()
        setConstraints()
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLogs()
    }

    // MARK: - Private methods

    private func setupUI() {
        view.layer.addSublayer(gradientLayer)
        view.addSubview(loginLabel)
        view.addSubview(loginButton)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(incorrectEmailLabel)
        view.addSubview(incorrectPasswordLabel)
        emailTextField
            .setPlaceholderText(textFieldConfiguretor: TextFieldConfiguretor(
                placeholderText: Local.AutorizationView
                    .emailPlaceholder
            ))
        emailTextField.leftView = emailLeftView
        emailTextField.rightView = emailRightView
        passwordTextField
            .setPlaceholderText(textFieldConfiguretor: TextFieldConfiguretor(
                placeholderText: Local.AutorizationView
                    .passwordPlaceholder
            ))
        passwordTextField.leftView = passwordLeftView
        passwordTextField.rightView = passwordRightView
        loginButton.addSubview(spinner)
        emailTextField.addTarget(self, action: #selector(handleTextChange(sender:)), for: .editingDidEnd)
        passwordRightView.addSubview(passwordHideButton)
        passwordHideButton.addTarget(self, action: #selector(changeVisablePassword), for: .touchUpInside)
    }

    private func setupKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setConstraints() {
        makeLoginLabelConstants()
        makeLoginButtonConstants()
        makeEmailLabelConstants()
        makeEmailTextFieldsConstants()
        makePasswordLabelConstants()
        makePasswordTextFieldsConstants()
        makeIncorrectPassConstants()
        makeIncorrectEmailConstants()
        makespinnerConstants()
    }

    private func okButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: Local.AutorizationView.toolBarOkButtonText,
            style: .done,
            target: self,
            action: #selector(hideKeyboard)
        )
        toolBar.items = [flexSpace, doneButton]
        toolBar.isUserInteractionEnabled = true
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
    }

    private func addGradientLayer() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(named: ColorPalette.loginGradient.rawValue)?.cgColor ?? "",
        ]
    }

    private func addLogs() {
        presenter?.sendLog()
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func handleTextChange(sender: UITextField) -> Bool {
        emailTextField.rightViewMode = .always
        switch validityTypes[sender.tag] {
        case .email:
            guard let emailText = emailTextField.text else { return false }
            if presenter?.isValid(enteringEmail: emailText, enteringPassword: nil) == false {
                incorrectEmailLabel.isHidden = false
                emailLabel.textColor = .red
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return false
            } else {
                incorrectEmailLabel.isHidden = true
                emailLabel.textColor = UIColor(named: ColorPalette.loginText.rawValue)
                emailTextField.layer.borderColor = UIColor.systemGray5.cgColor
            }
        case .password:
            guard let emailText = emailTextField.text else { return false }
            guard let passwordText = passwordTextField.text else { return false }
            if presenter?.isValid(enteringEmail: emailText, enteringPassword: passwordText) == false {
                incorrectPasswordLabel.isHidden = false
                passwordLabel.textColor = .red
                emailLabel.textColor = .red
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return false
            } else {
                incorrectPasswordLabel.isHidden = true
                passwordLabel.textColor = UIColor(named: ColorPalette.loginText.rawValue)
                emailLabel.textColor = UIColor(named: ColorPalette.loginText.rawValue)
                passwordTextField.layer.borderColor = UIColor.systemGray5.cgColor
                emailTextField.layer.borderColor = UIColor.systemGray5.cgColor
            }
        }
        return true
    }

    @objc private func loginAction() {
        hideKeyboard()
        if handleTextChange(sender: passwordTextField) {
            Timer.scheduledTimer(
                timeInterval: 3.0,
                target: self,
                selector: #selector(loadingHandler),
                userInfo: nil,
                repeats: false
            )
            spinner.startAnimating()
            loginButton.setTitle("", for: .normal)
        } else {
            createErrorView()
        }
    }

    @objc private func loadingHandler() {
        spinner.stopAnimating()
        loginButton.setTitle(Local.AutorizationView.loginText, for: .normal)
        presenter?.goToMainView()
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue else { return }
        loginButtonBottomConstraint.constant = -keyboardSize.height - 10
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification _: Notification) {
        loginButtonBottomConstraint.constant = -71
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func changeVisablePassword() {
        presenter?.changePasswordVisableState()
    }
}

// MARK: - Добавление экрана ошибки ввода данных

extension AutorizationViewController {
    private func createErrorView() {
        view.addSubview(errorView)
        errorView.addSubview(errorLabel)
        makeErrorLabelConstaints()
        makeErrorViewConstraints()
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.errorWiewConstraint.constant = -87
            self.view.layoutIfNeeded()
        }
        Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(hideError),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func hideError() {
        UIView.animate(withDuration: 0.5) {
            self.errorWiewConstraint.constant = 87
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - AutorizationViewController + AutorizationViewProtocol

extension AutorizationViewController: AutorizationViewProtocol {
    func changePasswordvisableState(isVisable: Bool) {
        if isVisable {
            passwordHideButton.setImage(UIImage(named: ImageName.visibility.rawValue), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordHideButton.setImage(UIImage(named: ImageName.unvisibility.rawValue), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
}

// MARK: - Типы полей ввода на экране

extension AutorizationViewController {
    /// Тип проверяемого поля
    enum ValidityType {
        /// Емайл
        case email
        /// Пароль
        case password
    }
}

// MARK: - Функции установки констрейнтов

extension AutorizationViewController {
    private func makeLoginLabelConstants() {
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 82).isActive = true
        loginLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }

    private func makeLoginButtonConstants() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButtonBottomConstraint.isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func makeEmailLabelConstants() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 23).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    private func makeEmailTextFieldsConstants() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func makePasswordLabelConstants() {
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 23).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    private func makePasswordTextFieldsConstants() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 6).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func makeIncorrectPassConstants() {
        incorrectPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        incorrectPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        incorrectPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 1)
            .isActive = true
        incorrectPasswordLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
    }

    private func makeIncorrectEmailConstants() {
        incorrectEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        incorrectEmailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        incorrectEmailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 1).isActive = true
        incorrectEmailLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
    }

    private func makespinnerConstants() {
        spinner.widthAnchor.constraint(equalToConstant: 25).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 25).isActive = true
        spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
    }

    private func makeErrorLabelConstaints() {
        errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 15).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -15).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -15).isActive = true
        errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 15).isActive = true
    }

    private func makeErrorViewConstraints() {
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        errorWiewConstraint.isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 87).isActive = true
    }
}
