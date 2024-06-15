// RecipeDetailPresenter.swift

import Foundation

/// Протокол презентера экрана деталей рецептов
protocol RecipeDetailPresenterProtocol: AnyObject {
    /// Инициализатор с присвоением вью
    init(
        view: RecipeDetailViewProtocol,
        coordinator: RecipesDetailCoordinatorProtocol,
        recipeURI: String,
        networkService: NetworkServiceProtocol?,
        loggerService: LoggerServiceProtocol?,
        favoriteRecipesStorage: FavoriteRecipesStorageProtocol?
    )
    /// Сохранение рецепта в исзбранное
    func saveToFavorite()
    /// Шеринг рецепта
    func shareRecipe()
    /// Экшн кнопки назад
    func back()
    /// Добавление логов
    func sendLog()
    /// Получить данные
    func getRecipeFromNetwork(comlition: VoidHandler?)
    /// Загрузить картинку для ячейки
    func loadImageDataForCell(_ imageURL: String, complitionHandler: @escaping (Data) -> Void)
    /// Состояние данных экрана деталей
    var state: ViewState<RecipeDetails> { get set }
}

/// Презентер экрана деталей рецептов
final class RecipeDetailPresenter: RecipeDetailPresenterProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol?
    private weak var coordinator: RecipesDetailCoordinatorProtocol?
    private weak var view: RecipeDetailViewProtocol?
    private var loggerService: LoggerServiceProtocol?
    private var recipeURI: String
    private var isFirstRequest = true
    private var imageData: Data?
    private var favoriteRecipesStorage: FavoriteRecipesStorageProtocol?
    var state: ViewState<RecipeDetails> = .loading {
        didSet {
            view?.updateState()
        }
    }

    // MARK: - Initializers

    required init(
        view: RecipeDetailViewProtocol,
        coordinator: RecipesDetailCoordinatorProtocol,
        recipeURI: String,
        networkService: NetworkServiceProtocol?,
        loggerService: LoggerServiceProtocol?,
        favoriteRecipesStorage: FavoriteRecipesStorageProtocol?
    ) {
        self.view = view
        self.coordinator = coordinator
        self.recipeURI = recipeURI
        self.networkService = networkService
        self.loggerService = loggerService
        self.favoriteRecipesStorage = favoriteRecipesStorage
    }

    // MARK: - Public Methods

    func back() {
        coordinator?.backToRecipes()
    }

    func saveToFavorite() {
        guard case let .data(recipe) = state,
              let favoritesStorage = favoriteRecipesStorage?.favoriteRecipes
        else { return }

        if favoritesStorage.contains(where: { favoriteRecipe in
            favoriteRecipe.label == recipe.label
        }) {
            favoriteRecipesStorage?.favoriteRecipes?.removeAll { favoriteRecipe in
                favoriteRecipe.label == recipe.label
            }
            view?.changeFavoriteButtonColor(isFavorite: false)
        } else {
            favoriteRecipesStorage?.favoriteRecipes?.append(RecipeCard(
                label: recipe.label,
                image: recipe.label,
                totalTime: recipe.totalTime,
                calories: recipe.calories,
                uri: recipe.uri,
                imageData: imageData
            ))
            view?.changeFavoriteButtonColor(isFavorite: true)
        }
    }

    func shareRecipe() {
        guard case let .data(data) = state else { return }
        loggerService?.log(.tapShareButton)
        coordinator?.shareRecipe(text: data.ingredients)
    }

    func sendLog() {
        loggerService?.log(.openDetailsRecipe)
    }

    func loadImageDataForCell(_ imageURL: String, complitionHandler: @escaping (Data) -> Void) {
        networkService?.getImageData(stringURL: imageURL) { [weak self] result in
            if case let .success(data) = result {
                self?.imageData = data
                complitionHandler(data)
            }
        }
    }

    func getRecipeFromNetwork(comlition: VoidHandler? = nil) {
        state = .loading
        networkService?.getDetail(uri: recipeURI) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(recipeDetails):
                    self.state = .data(recipeDetails)

                    var favoriteRecipes = self.favoriteRecipesStorage?.favoriteRecipes

                    if favoriteRecipes == nil {
                        favoriteRecipes = []
                    }
                    guard let favoriteRecipes = favoriteRecipes else { return }

                    if favoriteRecipes.contains(where: { favoriteRecipe in
                        favoriteRecipe.label == recipeDetails.label
                    }) {
                        self.view?.changeFavoriteButtonColor(isFavorite: true)
                    } else {
                        self.view?.changeFavoriteButtonColor(isFavorite: false)
                    }

                case let .failure(error):
                    self.state = .error(error) {}
                }
                comlition?()
            }
        }
    }
}
