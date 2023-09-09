//
//  UserListView.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import SwiftUI
struct UserListView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = UserViewModel()
    var body: some View {
        NavigationView {
            ZStack{
                Color(hex: colorScheme == .dark ? "#ADB0BC" :   "#F5F5F5")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    LazyVStack{
                        ForEach(viewModel.users, id:\.uuid) { user in
                            let cardViewModel = UserCardViewModel(user: user) { action in
                                viewModel.handleUserAction(userStatus: action, user: user)
                            }
                            UserCardView(cardViewModel: cardViewModel)
                        }
                    }

                }
                
                if  viewModel.isLoading {
                    ProgressView {
                        Text("Loading")
                    }
                    .foregroundColor(AppColor.themeColor)
                }
            }
            .listStyle(PlainListStyle())
            .onAppear(){
                viewModel.fetchUserData()
            }
            .alert(item: $viewModel.alertDescription) { alert in
                Alert(title: Text("Alert"), message: Text(alert.message), dismissButton: .cancel(Text("OK")))
            }
            .navigationTitle(Text("MatchMate"))
        }
    }
}


struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
