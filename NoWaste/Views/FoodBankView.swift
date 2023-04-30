//
//  FoodBankView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 30/04/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FoodBankView: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var address: String = ""
    @State var image: URL? = URL(string: "https://i.mbgrp.com.mx/placeholder.jpg")
    @State var role: String = ""
    @State var firebaseID: String = ""
    @State var pendingDonations = [Donation]()
    @State var acceptedDonations = [Donation]()
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    @State var isLoggedIn: Bool = true
    
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
                    self.name = name
                    self.email = email
                    self.role = role
                    self.address = address
                    self.image = URL(string: image)
                    self.firebaseID = user.uid
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func getAcceptedDonations(){
        db.collection("donations").whereField("status", isEqualTo: "accepted").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let data = document.data()
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                    let dateOfDonation = data["dateOfDonation"] as? Timestamp ?? Timestamp()
                    let commerceID = data["commerceID"] as? String ?? ""
                    let commerceName = data["commerceName"] as? String ?? ""
                    let commerceAddress = data["commerceAddress"] as? String ?? ""
                    let commerceIMG = data["commerceIMG"] as? String ?? ""
                    let typeOfDonation = data["typeOfDonation"] as? String ?? ""
                    let status = data["status"] as? String ?? ""
                    let uuid = data["uuid"] as? String ?? ""
                    let acceptedBy = data["acceptedBy"] as? String ?? ""
                    
                    let donation = Donation(timestamp: timestamp.dateValue(), dateOfDonation: dateOfDonation.dateValue(), commerceID: commerceID, commerceName: commerceName, commerceAddress: commerceAddress, commerceIMG: commerceIMG, typeOfDonation: typeOfDonation, status: status, uuid: uuid, acceptedBy: acceptedBy, deliveryBy: "")
                    // Append donation to array only if it is not already in the array
                    if !acceptedDonations.contains(donation){
                        acceptedDonations.append(donation)
                    }
                    
                }
            }
        }
    }
    
    // Get all pending donations from any user from firestore and display them with a button to accept or reject them
    func getPendingDonations(){
        db.collection("donations").whereField("status", isEqualTo: "pending").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let data = document.data()
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                    let dateOfDonation = data["dateOfDonation"] as? Timestamp ?? Timestamp()
                    let commerceID = data["commerceID"] as? String ?? ""
                    let commerceName = data["commerceName"] as? String ?? ""
                    let commerceAddress = data["commerceAddress"] as? String ?? ""
                    let commerceIMG = data["commerceIMG"] as? String ?? ""
                    let typeOfDonation = data["typeOfDonation"] as? String ?? ""
                    let status = data["status"] as? String ?? ""
                    let uuid = data["uuid"] as? String ?? ""
                    let acceptedBy = data["acceptedBy"] as? String ?? ""
                    let deliveryBy = data["deliveryBy"] as? String ?? ""
                    
                    let donation = Donation(timestamp: timestamp.dateValue(), dateOfDonation: dateOfDonation.dateValue(), commerceID: commerceID, commerceName: commerceName, commerceAddress: commerceAddress, commerceIMG: commerceIMG, typeOfDonation: typeOfDonation, status: status, uuid: uuid, acceptedBy: acceptedBy)
                    // Append donation to array only if it is not already in the array
                    if !pendingDonations.contains(donation){
                        pendingDonations.append(donation)
                    }
                    
                }
            }
        }
    }
    
    
    var body: some View {
        // Get all pending donations from any user from firestore and display them with a button to accept or reject them
        VStack{
            HStack {
                Text("Bienvenido, \(name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.black))
                Spacer()
                VStack{
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            do {
                                try auth.signOut()
                                self.isLoggedIn = false
                            } catch {
                                print("Error signing out")
                            }
                        }
                    }, label: {
                        HStack{
                            Text("Cerrar Sesión")
                                .font(.caption2)
                                .foregroundColor(Color(.black))
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .font(.caption2)
                                .foregroundColor(Color(.black))
                        }
                    })
                    AsyncImage(
                        url: image!) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                }.padding()
            }.padding()
            Text("Donaciones que puedes aceptar")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            List(pendingDonations, id: \.self){ donation in
                HStack{
                    AsyncImage(
                        url: URL(string: donation.commerceIMG)!) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }.padding()
                    VStack(alignment: .leading){
                        Text(donation.typeOfDonation)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(donation.commerceName)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(donation.commerceAddress)
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(donation.dateOfDonation, style: .date)
                            .font(.caption)
                            .fontWeight(.regular)
                    }.scrollContentBackground(.hidden)
                        .listStyle(PlainListStyle())
                    Spacer()
                    VStack{
                        Button(action: {
                            // Accept donation by searching uuid in firestore and updating status to accepted
                            
                            db.collection("donations").whereField("uuid", isEqualTo: donation.uuid).getDocuments { (querySnapshot, error) in
                                if let querySnapshot = querySnapshot {
                                    for document in querySnapshot.documents {
                                        db.collection("donations").document(document.documentID).updateData(["status": "acceptedByFoodbank"])
                                        db.collection("donations").document(document.documentID).updateData(["acceptedBy": self.firebaseID])
                                    }
                                }
                            }
                            acceptedDonations.append(donation)
                            pendingDonations.removeAll(where: { $0.uuid == donation.uuid })
                        }, label: {
                            ZStack{
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(.black))
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.white))
                            }
                        })
                    }
                }
            }
            Text("Donaciones Aceptadas")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            List(acceptedDonations, id: \.self){ donation in
                HStack{
                    VStack(alignment: .leading){
                        Text(donation.typeOfDonation)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(donation.commerceName)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(donation.commerceAddress)
                            .font(.caption)
                            .fontWeight(.bold)
                        Text(donation.dateOfDonation, style: .date)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
            }
        }.onAppear{
            getUserData()
            getPendingDonations()
            getAcceptedDonations()
        }
    }
}

struct FoodBankView_Previews: PreviewProvider {
    static var previews: some View {
        FoodBankView()
    }
}
