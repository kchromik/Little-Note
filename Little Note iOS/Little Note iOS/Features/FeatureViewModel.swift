//
//  FeatureViewModel.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 28.08.24.
//

import LittleBase
import SwiftUI
import FirebaseFirestore

struct Feature: Identifiable {
    var id: String
    var title: String
    var description: String
    var upvotes: Int
    var userUpvoted: Bool
}

extension FeaturesList {

    class ViewModel: ObservableObject {

        @Published var features: [Feature] = []
        private var db = Firestore.firestore()

        init() {
            initDeviceId()
            fetchFeatures()
        }

        func initDeviceId() {
            guard UserDefaults.deviceID.isNil else { return }
            UserDefaults.deviceID = UUID().uuidString
        }

        func fetchFeatures() {
            db.collection("features").addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }

                self.features = documents.map { docSnapshot -> Feature in
                    let data = docSnapshot.data()
                    let title = data["title"] as? String ?? ""
                    let upvotes = data["upvotes"] as? Int ?? 0
                    let userUpvotes = data["userUpvotes"] as? [String: Bool] ?? [:]
                    let description = data["description"] as? String ?? ""

                    // Replace "deviceID" with actual device unique ID.
                    let userUpvoted = userUpvotes["deviceID"] ?? false

                    return Feature(
                        id: docSnapshot.documentID,
                        title: title,
                        description: description,
                        upvotes: upvotes,
                        userUpvoted: userUpvoted
                    )
                }
            }
        }

        func toggleUpvote(feature: Feature) {
            let featureRef = db.collection("features").document(feature.id)
            let userIdentifier = UserDefaults.deviceID ?? ""

            db.runTransaction { (transaction, errorPointer) -> Any? in
                let featureSnapshot: DocumentSnapshot
                do {
                    try featureSnapshot = transaction.getDocument(featureRef)
                } catch let fetchError {
                    print("Error fetching feature: \(fetchError)")
                    return nil
                }

                guard let oldUpvotes = featureSnapshot.data()?["upvotes"] as? Int else {
                    return nil
                }
                var newUpvotes = oldUpvotes
                var userUpvotes = featureSnapshot.data()?["userUpvotes"] as? [String: Bool] ?? [:]

                if userUpvotes[userIdentifier] == true {
                    // User is removing their upvote
                    newUpvotes -= 1
                    userUpvotes[userIdentifier] = false
                } else {
                    // User is adding an upvote
                    newUpvotes += 1
                    userUpvotes[userIdentifier] = true
                }

                transaction.updateData(["upvotes": newUpvotes, "userUpvotes": userUpvotes], forDocument: featureRef)
                return nil
            } completion: { (_, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                }
            }
        }
    }

}
