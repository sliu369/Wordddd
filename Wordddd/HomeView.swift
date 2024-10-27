//
//  HomeView.swift
//  Wordddd
//
//  Created by Sijun Liu on 2024-10-27.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var wordManager = WordManager()
    @State private var showingNewWord = false
    @State private var showingPractice = false
    @State private var showingWordBank = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Button(action: {
                    showingNewWord = true
                }) {
                    HomeButton(title: "New Word", 
                             systemImage: "plus.circle.fill",
                             color: .blue)
                }
                
                Button(action: {
                    showingPractice = true
                }) {
                    HomeButton(title: "Start Practice", 
                             systemImage: "play.circle.fill",
                             color: .green)
                }
                
                Button(action: {
                    showingWordBank = true
                }) {
                    HomeButton(title: "Word Bank", 
                             systemImage: "book.fill",
                             color: .purple)
                }
                
                Text("\(wordManager.words.count) words in your collection")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            .padding()
            .navigationTitle("Word Memory")
        }
        .sheet(isPresented: $showingNewWord) {
            NewWordView(wordManager: wordManager)
        }
        .sheet(isPresented: $showingPractice) {
            PracticeView(wordManager: wordManager)
        }
        .sheet(isPresented: $showingWordBank) {
            WordBankView(wordManager: wordManager)
        }
    }
}

struct HomeButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.system(size: 24))
            Text(title)
                .font(.title2)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .cornerRadius(10)
    }
}

#Preview {
    HomeView()
}
