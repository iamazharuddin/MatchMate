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
               (colorScheme == .dark ?  AppColorConstant.bgColorDarkMode :  AppColorConstant.bgColorLightMode)
                    .edgesIgnoringSafeArea(.all)
                ScrollView{
                    LazyVStack{
                        ForEach(viewModel.users) { user in
                            let cardViewModel = UserCardViewModel(user: user) { action in
                                viewModel.handleUserAction(userStatus: action, user: user)
                            }
                            UserCardView(cardViewModel: cardViewModel)
                        }
                    }
                }
                if  viewModel.isLoading {
                    ProgressView()
                }
            }
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
