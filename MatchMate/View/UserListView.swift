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
                        let cardViewModel = CardViewModel(user: user) { action in
                            viewModel.handleUserAction(userStatus: action, user: user)
                        }
                        CardView(cardViewModel: cardViewModel)
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                }
            }
            .listStyle(PlainListStyle())
            .onAppear(){
                viewModel.fetchUserData()
            }.navigationTitle(Text("MatchMate"))
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
