// ImagePicker.swift

import UIKit

/// Экран камеры
final class ImagePicker: NSObject, UINavigationControllerDelegate {
    // MARK: - Private Properties

    private var imagePickerController = UIImagePickerController()
    private var comlition: ((UIImage) -> Void)?

    // MARK: - Public Methods

    func showImagePicker(in viewController: UIViewController, complition: ((UIImage) -> Void)?) {
        comlition = complition
        imagePickerController.delegate = self
        viewController.present(imagePickerController, animated: true)
    }
}

// MARK: - ImagePicker + UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            comlition?(image)
            picker.dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
