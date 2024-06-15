// RecepeCategoryView.swift

import UIKit

/// Протокол экрана рецептов
protocol RecepeCategoryViewProtocol: AnyObject {
    ///  Презентер экрана
    var presenter: RecepeCategoryPresenterProtocol? { get set }
    /// Обновление состояния
    func updateState()
}

/// Экран рецептов
final class RecepeCategoryView: UIViewController {
    // MARK: - Constants

    enum Constants {
        static let buttonSortHigh: CGFloat = 36
    }

    // MARK: - Visual Components

    private let backBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageName.arrow.rawValue), for: .normal)
        button.accessibilityIdentifier = Local.DishesBackButton.accessibilityIdentifier
        return button
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 28)
        label.textColor = .black
        return label
    }()

    private let barView = UIView()

    private let recipesSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Local.RecepeCategoryView.seatchBarText
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 12
        searchBar.searchTextField.backgroundColor = UIColor(named: ColorPalette.deviderLight.rawValue)
        return searchBar
    }()

    private let searchGlassImageView = UIImageView(image: UIImage(named: ImageName.searchGlass.rawValue))
    private let sortPickerView = SortPickerView()
    private let tableView = UITableView()
    private lazy var refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refrashHandle(sender:)), for: .valueChanged)
        return refreshControll
    }()

    // MARK: - Public Properties

    var presenter: RecepeCategoryPresenterProtocol?

    // MARK: - Private Properties

    private var sortButtons: [UIButton] = []
    private let sortTypes: [SortTypes] = [.calories, .time]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        configureTableView()
        createConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLogs()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deselectedSelectedRow()
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        categoryLabel.text = navigationItem.title
        navigationItem.title = nil
        barView.addSubview(backBarButton)
        barView.addSubview(categoryLabel)
        createBackBarButtonConstraints()
        createCategoryLabelConstraints()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barView)
        backBarButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }

    private func configureTableView() {
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        tableView.register(RecipeSkeletonCell.self, forCellReuseIdentifier: RecipeSkeletonCell.identifier)
        tableView.register(RecipeNoDataCell.self, forCellReuseIdentifier: RecipeNoDataCell.identifier)
        tableView.register(RecipeErrorCell.self, forCellReuseIdentifier: RecipeErrorCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControll)
        tableView.accessibilityIdentifier = Local.DishesTableView.accessibilityIdentifier
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(recipesSearchBar)
        sortPickerView.dataSource = self
        recipesSearchBar.delegate = self
        view.addSubview(sortPickerView)
        view.addSubview(tableView)
        presenter?.getRecipesFromNetwork(search: nil, complition: nil)
    }

    private func createConstraints() {
        createSearchBarConstraints()
        createBarViewConstraints()
        createSortPickerViewConstraints()
        createTableViewConstraints()
    }

    private func deselectedSelectedRow() {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: selectedIndex)?.isSelected = false
        }
    }

    private func addLogs() {
        presenter?.sendLog()
    }

    private func createBackBarButtonConstraints() {
        backBarButton.translatesAutoresizingMaskIntoConstraints = false
        backBarButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backBarButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backBarButton.leadingAnchor.constraint(equalTo: barView.leadingAnchor).isActive = true
        backBarButton.topAnchor.constraint(equalTo: barView.topAnchor).isActive = true
    }

    private func createCategoryLabelConstraints() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: backBarButton.trailingAnchor, constant: 20).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: barView.topAnchor).isActive = true
    }

    private func createBarViewConstraints() {
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func createSearchBarConstraints() {
        recipesSearchBar.translatesAutoresizingMaskIntoConstraints = false
        recipesSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .isActive = true
        recipesSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        recipesSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .isActive = true
        recipesSearchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    private func createSortPickerViewConstraints() {
        sortPickerView.translatesAutoresizingMaskIntoConstraints = false
        sortPickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .isActive = true
        if sortTypes.count * 100 > Int(view.frame.width) {
            sortPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            sortPickerView.widthAnchor.constraint(equalToConstant: CGFloat(sortTypes.count * 100))
                .isActive = true
        }
        sortPickerView.topAnchor.constraint(equalTo: recipesSearchBar.bottomAnchor, constant: 20).isActive = true
        sortPickerView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    private func createTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: sortPickerView.bottomAnchor, constant: 15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc private func back() {
        presenter?.back()
    }

    @objc private func refrashHandle(sender: UIRefreshControl) {
        presenter?.getRecipesFromNetwork(search: nil) {
            sender.endRefreshing()
        }
    }
}

// MARK: - RecepeCategoryView + RecepeCategoryViewProtocol

extension RecepeCategoryView: RecepeCategoryViewProtocol {
    func updateState() {
        tableView.reloadData()
    }
}

// MARK: - RecepeCategoryView + SortPickerViewDataSource

extension RecepeCategoryView: SortPickerViewDataSource {
    func sortPickerAction(indexPath: IndexPath, newSortState: SortState) {
        presenter?.selectedSort(sortTypes[indexPath.row], newSortState: newSortState)
    }

    func sortPickerCount(_: SortPickerView) -> Int {
        sortTypes.count
    }

    func sortPickerTitle(_: SortPickerView, indexPath: IndexPath) -> String {
        sortTypes[indexPath.item].rawValue
    }
}

// MARK: - RecepeCategoryView + UITableViewDataSource

extension RecepeCategoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch presenter?.state {
        case let .data(recipes):
            tableView.isScrollEnabled = true
            tableView.allowsSelection = true
            return recipes.count
        case .noData, .error:
            return 1
        default:
            tableView.isScrollEnabled = false
            tableView.allowsSelection = false
            return 8
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter?.state {
        case let .data(recipes):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeCell.identifier,
                for: indexPath
            ) as? RecipeCell else { return UITableViewCell() }
            cell.loadInfo(recipe: recipes[indexPath.row])
            cell.cellID = indexPath
            presenter?.loadImageDataForCell(recipes[indexPath.row].image) { data in
                if cell.cellID == indexPath {
                    DispatchQueue.main.async {
                        cell.setImage(imageData: data)
                    }
                }
            }
            return cell
        case .loading:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeSkeletonCell.identifier,
                for: indexPath
            ) as? RecipeSkeletonCell else { return UITableViewCell() }
            return cell
        case .noData:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeNoDataCell.identifier,
                for: indexPath
            ) as? RecipeNoDataCell else { return UITableViewCell() }
            return cell
        case .error, .none:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecipeErrorCell.identifier,
                for: indexPath
            ) as? RecipeErrorCell else { return UITableViewCell() }
            cell.reloadDataHandler = { [weak self] in
                self?.presenter?.getRecipesFromNetwork(search: nil, complition: nil)
            }
            return cell
        }
    }
}

// MARK: - RecepeCategoryView + UITableViewDelegate

extension RecepeCategoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToRecipeDetail(numberOfRecipe: indexPath.row)
        tableView.cellForRow(at: indexPath)?.isSelected = true
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

// MARK: - RecepeCategoryView + UISearchBarDelegate

extension RecepeCategoryView: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        presenter?.searchRecipes(withText: searchText.count >= 3 ? searchText : "")
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        presenter?.searchRecipes(withText: "")
    }
}
