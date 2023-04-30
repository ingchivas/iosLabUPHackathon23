//
//  LoginView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        NavigationView{
            VStack{
                Image("NoWasteLogo")
                    .resizable()
                    .frame(width: 350, height: 100)
                    .padding()
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .cornerRadius(10.0)
                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.black, lineWidth: 1))
                    .padding()
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(10.0)
                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.black, lineWidth: 1))
                    .padding()
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "Error")
                        } else {
                            print("User logged in")
                        }
                    }
                }){
                    Text("Login")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.6)]), startPoint: .leading, endPoint: .trailing)
                        ).cornerRadius(30)
                        .shadow(radius: 8,x: 4,y:4)
                }
                .padding(.bottom, 20)
                NavigationLink(destination: RegisterView()){
                    Text("Registrarse")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.white).cornerRadius(30)
                        .shadow(radius: 8,x: 4,y:4)
                }
                .padding(.bottom, 20)
                Image("Group 7")
                    .frame(height: 160)
                    .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
