//
//  UserListView.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import SwiftUI
struct UserListView: View {
    @StateObject var viewModel = UserViewModel()
    var body: some View {
        NavigationView {
            ZStack{
                List {
                    ForEach(viewModel.users, id:\.uuid) { user in
                        let cardViewModel = UserCardViewModel(user: user) { action in
                            viewModel.handleUserAction(userStatus: action, user: user)
                        }
                        UserCardView(cardViewModel: cardViewModel)
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
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
            if  viewModel.isLoading {
                ProgressView {
                    Text("Loading")
                }
                .foregroundColor(AppColor.themeColor)
            }
            
        }
    }
}


struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
