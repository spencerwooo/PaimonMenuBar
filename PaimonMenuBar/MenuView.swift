//
//  MenuView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/24.
//

import Foundation
import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("更新于 16:13")
                .font(.caption)
                .foregroundColor(.gray)

            HStack {
                Image("FragileResin")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("当前树脂")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)

            Text("153/160")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.title, design: .monospaced))

            Divider()

            HStack {
                Label("距离全部恢复", systemImage: "hourglass.circle")
                    .foregroundColor(.gray)
                Spacer()
                Text("0 小时 48 分钟")
            }
            HStack {
                Label("恢复于本日", systemImage: "clock")
                    .foregroundColor(.gray)
                Spacer()
                Text("16 点 41 分")
            }

            Divider()

            Button {
                Task {
                    let gameRecord = await getGameRecord()
                    if gameRecord == nil {
                        return
                    }
                    print(gameRecord!)
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
        .padding()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().frame(width: 280, height: 400)
    }
}
