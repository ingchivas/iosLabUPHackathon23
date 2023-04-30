//
//  ContentView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var role: String
    var address: String
    var image: URL
}

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User = User(name: "", email: "", role: "", address: "", image: URL(string: "https://i.mbgrp.com.mx/placeholder.jpg")!)
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func listen() {
        auth.addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.isLoggedIn = true
                self.getUserData()
            } else {
                self.isLoggedIn = false
            }
        }
    }
    
    func getUserData()
    {
        let user = Auth.auth().currentUser
        if let user = user {
            db.collection("users").document(user.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["name"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    let role = data?["role"] as? String ?? ""
                    let address = data?["address"] as? String ?? ""
                    let image = data?["userIMG"] as? String ?? ""
                    self.user = User(name: name, email: email, role: role, address: address, image: URL(string: image)!)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func logOut() {
        try! auth.signOut()
    }
}

struct ContentView: View {
    @ObservedObject var session = UserSession()
    var body: some View {
        Group {
            if session.isLoggedIn && session.user.role == "commerce" {
                CommerceView()
            } else if session.isLoggedIn && session.user.role == "foodbank" {
                FoodBankView()
            }
            else if session.isLoggedIn && session.user.role == "delivery"{
                DeliveryView()
            }
            else{
                Onboarding()
            }
        }.onAppear(perform: session.listen)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
