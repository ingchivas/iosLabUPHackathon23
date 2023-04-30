//
//  RegisterView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    @State private var name: String = ""
    @State private var role: String = ""
    @State private var address: String = ""
    @State private var userIMG : String = "https://i.mbgrp.com.mx/placeholder.jpg"
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("Registro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                TextField("Nombre", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .autocorrectionDisabled()
                    .padding()
                TextField("Correo", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .padding()
                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding()
                SecureField("Confirmar contraseña", text: $password2)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding()
                TextField("Dirección", text: $address)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding()
                Text("Selecciona tu rol:")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                Picker(selection: $role, label: Text("Rol")) {
                    Text("Selecciona tu rol").tag("")
                    Text("Comercio").tag("commerce")
                    Text("Banco de alimentos").tag("foodbank")
                    Text("Delivery").tag("delivery")
                }.padding()
                
            }
            Button(action: {
                if password == password2 {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error as NSError? {
                            print(error.localizedDescription)
                        } else {
                            let db = Firestore.firestore()
                            db.collection("users").document(authResult!.user.uid).setData([
                                "name": name,
                                "email": email,
                                "role": role,
                                "address": address,
                                "userIMG" : userIMG
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                            print("User signed up successfully")
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let error = error as NSError? {
                                    print(error.localizedDescription)
                                } else {
                                    print("User signed in successfully")
                                }
                            }
                        }
                    }
                } else {
                    print("Passwords don't match")
                }
            }, label: {
                Text("Registrarse")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.white).cornerRadius(30)
                    .shadow(radius: 8,x: 4,y:4)
            })
        }
        
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
