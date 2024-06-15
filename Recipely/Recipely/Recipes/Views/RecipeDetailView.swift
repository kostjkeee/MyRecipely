// RecipeDetailView.swift

import UIKit

/// Протокол экрана деталей рецептов
protocol RecipeDetailViewProtocol: AnyObject {
    /// Презентер экрана
    var presenter: RecipeDetailPresenterProtocol? { get set }
    /// Установка цвета кнопки фаворита
    func changeFavoriteButtonColor(isFavorite: Bool)
    /// Обновление состояния
    func updateState()
}

/// Экран деталей рецепта
final class RecipeDetailView: UIViewController {
    enum Details {
        /// Фото блюда
        case photo
        /// Характеристики
        case characteristics
        /// Описание
        case description
    }

    // MARK: - Visual Components

    private let backBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageName.arrow.rawValue), for: .normal)
        button.accessibilityIdentifier = Local.DishesDetailsBackButton.accessibilityIdentifier
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageName.sendIcon.rawValue), for: .normal)
        button.accessibilityIdentifier = Local.ShareButton.accessibilityIdentifier
        return button
    }()

    private let setFavorite: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageName.saveIcon.rawValue), for: .normal)
        button.accessibilityIdentifier = Local.AddFavoritesButton.accessibilityIdentifier
        return button
    }()

    private let barView = UIView()

    private let recipeLabel: UILabel = {
        let recipeLabel = UILabel()
        recipeLabel.font = .verdanaBold(ofSize: 20)
        recipeLabel.numberOfLines = 0
        recipeLabel.textAlignment = .center
        return recipeLabel
    }()

    private lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refrashHandle(sender:)), for: .valueChanged)
        return refreshControll
    }()

    private let recipeLabelView = UIView()
    private let tableView = UITableView(frame: CGRect(), style: .grouped)

    // MARK: - Public Properties

    var presenter: RecipeDetailPresenterProtocol?

    // MARK: - Private Properties

    private let recipeCells: [Details] = [.photo, .characteristics, .description]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTableView()
        setupNavigationBar()
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLogs()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        presenter?.getRecipeFromNetwork(comlition: nil)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        backBarButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        barView.addSubview(shareButton)
        barView.addSubview(setFavorite)
        createShareButtonConstraints()
        createSetFavoriteConstraints()
        createBarViewConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barView)
        setFavorite.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareRecipe), for: .touchUpInside)
    }

    private func setConstraints() {
        makeTableViewConstraints()
        createRecipeLabelConstraints()
    }

    private func setTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none

        tableView.register(RecipesImageDetailCell.self, forCellReuseIdentifier: RecipesImageDetailCell.identifier)
        tableView.register(DetailsSkeletonCell.self, forCellReuseIdentifier: DetailsSkeletonCell.identifier)
        tableView.register(RecipeNoDataCell.self, forCellReuseIdentifier: RecipeNoDataCell.identifier)
        tableView.register(RecipeErrorCell.self, forCellReuseIdentifier: RecipeErrorCell.identifier)
        tableView.register(
            RecipesCharacteristicsDetailsCell.self,
            forCellReuseIdentifier: RecipesCharacteristicsDetailsCell.identifier
        )
        tableView.register(
            RecipesDescriptionDetailsCell.self,
            forCellReuseIdentifier: RecipesDescriptionDetailsCell.identifier
        )

        recipeLabelView.addSubview(recipeLabel)
        tableView.addSubview(refreshControll)
        tableView.accessibilityIdentifier = Local.DishesDetailTableView.accessibilityIdentifier
    }

    private func addLogs() {
        presenter?.sendLog()
    }

    private func createRecipeLabelConstraints() {
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.leadingAnchor.constraint(equalTo: recipeLabelView.leadingAnchor).isActive = true
        recipeLabel.trailingAnchor.constraint(equalTo: recipeLabelView.trailingAnchor).isActive = true
        recipeLabel.centerYAnchor.constraint(equalTo: recipeLabelView.centerYAnchor).isActive = true
        recipeLabel.bottomAnchor.constraint(equalTo: recipeLabelView.bottomAnchor, constant: -10).isActive = true
    }

    private func createShareButtonConstraints() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: setFavorite.leadingAnchor, constant: -4).isActive = true
        shareButton.topAnchor.constraint(equalTo: barView.topAnchor).isActive = true
    }

    private func createSetFavoriteConstraints() {
        setFavorite.translatesAutoresizingMaskIntoConstraints = false
        setFavorite.heightAnchor.constraint(equalToConstant: 24).isActive = true
        setFavorite.widthAnchor.constraint(equalToConstant: 24).isActive = true
        setFavorite.trailingAnchor.constraint(equalTo: barView.trailingAnchor).isActive = true
        setFavorite.topAnchor.constraint(equalTo: barView.topAnchor).isActive = true
    }

    private func createBarViewConstraints() {
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }

    private func makeTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc private func back() {
        presenter?.back()
    }

    @objc private func saveHandler() {
        presenter?.saveToFavorite()
    }

    @objc private func shareRecipe() {
        presenter?.shareRecipe()
    }

    @objc private func reloadData() {
        presenter?.getRecipeFromNetwork(comlition: nil)
    }

    @objc private func refrashHandle(sender: UIRefreshControl) {
        presenter?.getRecipeFromNetwork {
            sender.endRefreshing()
        }
    }
}

// MARK: - Extensions

extension RecipeDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch presenter?.state {
        case .data:
            tableView.isScrollEnabled = true
            tableView.allowsSelection = true
            return recipeCells.count
        default:
            tableView.isScrollEnabled = false
            tableView.allowsSelection = false
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter?.state {
        case let .data(recipe):
            switch recipeCells[indexPath.row] {
            case .photo:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecipesImageDetailCell.identifier,
                    for: indexPath
                ) as? RecipesImageDetailCell else { return UITableViewCell() }
                recipeLabel.text = recipe.label
                cell.getInfo(recipe: recipe)
                presenter?.loadImageDataForCell(recipe.image) { data in
                    DispatchQueue.main.async {
                        cell.setImage(imageData: data)
                    }
                }
                return cell
            case .characteristics:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecipesCharacteristicsDetailsCell.identifier,
                    for: indexPath
                ) as? RecipesCharacteristicsDetailsCell else { return UITableViewCell() }
                cell.getCharacteristics(recipe: recipe)
                return cell
            case .description:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecipesDescriptionDetailsCell.identifier,
                    for: indexPath
                ) as? RecipesDescriptionDetailsCell else { return UITableViewCell() }
                cell.setText(recipe.ingredients)
                return cell
            }
        case .loading:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailsSkeletonCell.identifier,
                for: indexPath
            ) as? DetailsSkeletonCell else { return UITableViewCell() }
            return cell
        case .error, .noData, nil:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeErrorCell.identifier,
                for: indexPath
            ) as? RecipeErrorCell else { return UITableViewCell() }
            cell.reloadDataHandler = { [weak self] in
                self?.presenter?.getRecipeFromNetwork(comlition: nil)
            }
            return cell
        }
    }
}

extension RecipeDetailView: UITableViewDelegate {
    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        recipeLabelView
    }
}

// MARK: - RecipeDetailView + RecipeDetailViewProtocol

extension RecipeDetailView: RecipeDetailViewProtocol {
    func updateState() {
        tableView.reloadData()
    }

    func changeFavoriteButtonColor(isFavorite: Bool) {
        let saveImage: UIImage? = isFavorite ? UIImage(named: ImageName.saved.rawValue) :
            UIImage(named: ImageName.saveIcon.rawValue)
        setFavorite.setImage(saveImage, for: .normal)
    }
}
