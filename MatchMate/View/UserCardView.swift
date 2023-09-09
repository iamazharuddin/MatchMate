//
//  UserCardView.swift
//  MatchMate
//
//  Created by Azharuddin 1 on 08/09/23.
//

import SwiftUI
struct UserCardView: View {
    let cardViewModel: UserCardViewModel
    var body: some View {
        VStack(spacing: 0){
            CachedImage(urlString: cardViewModel.profileImageUrl)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
            
            Text(cardViewModel.fullName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColor.themeColor)
                .padding(.top, 10)
            
            Text(cardViewModel.completeAddress)
                .foregroundColor(AppColor.textColor)
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 5)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: cardViewModel.userStatus != .none ? 16 : 8)
            
            switch cardViewModel.userStatus{
            case .accepted:
                Text("Accepted")
                    .foregroundColor(.white)
                    .font(.body)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(AppColor.themeColor)
                    .cornerRadius(6)
            case .rejected:
                Text("Declined")
                    .foregroundColor(.white)
                    .font(.body)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(AppColor.themeColor)
                    .cornerRadius(6)
            case .none:
                HStack {
                    Button(action: {
                        cardViewModel.handleUserAction(.accepted)
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .padding(10)
                            .background(Circle().stroke(AppColor.themeColor, lineWidth: 4))
                            .clipShape(Circle())
                        
                    }.buttonStyle(PlainButtonStyle())
                    
                    Spacer().frame(width: 60)
                    
                    Button(action: {
                        cardViewModel.handleUserAction(.rejected)
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .padding(10)
                            .background(Circle().stroke(AppColor.themeColor, lineWidth: 4))
                            .clipShape(Circle())
                        
                    }.buttonStyle(PlainButtonStyle())
                }
                .foregroundColor(AppColor.textColor)
                .padding(.top, 20)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 8)
    }
    
}

