import FirebaseAuth
import FirebaseFirestore
import UIKit

final class FirebaseUserManager {
    static let shared = FirebaseUserManager()

    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()

    private init() {}

    func signUp(
        email: String,
        password: String,
        gender: Gender,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid, let self = self else {
                completion(.failure(NSError(domain: "UserIDError", code: -1, userInfo: nil)))
                return
            }

            let user = User(
                id: uid,
                name: email,
                gender: gender,
                photoPath: "",
                email: email,
                categories: DefaultCategories.all,
                source: .remote
            )

            self.saveUserToFirestore(user) { success in
                if success {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "FirestoreSaveError", code: -1, userInfo: nil)))
                }
            }
        }
    }

    func fetchUser(withID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                return
            }

            guard
                let name = data["name"] as? String,
                let genderRaw = data["gender"] as? String,
                let gender = Gender(rawValue: genderRaw),
                let photoPath = data["photoPath"] as? String,
                let email = data["email"] as? String,
                let categoriesArray = data["categories"] as? [[String: Any]]
            else {
                completion(.failure(NSError(domain: "ParseError", code: -1, userInfo: nil)))
                return
            }

            let categories = categoriesArray.compactMap { Category(dictionary: $0) }

            let user = User(
                id: uid,
                name: name,
                gender: gender,
                photoPath: photoPath,
                email: email,
                categories: categories,
                source: .remote
            )

            completion(.success(user))
        }
    }

    private func saveUserToFirestore(_ user: User, completion: @escaping (Bool) -> Void) {
        let categoriesDictArray = user.categories.map { $0.dictionaryRepresentation() }
        let userData: [String: Any] = [
            "name": user.name,
            "gender": user.gender.rawValue,
            "photoPath": user.photoPath,
            "email": user.email,
            "categories": categoriesDictArray
        ]

        firestore.collection("users").document(user.id).setData(userData) { error in
            completion(error == nil)
        }
    }
}
