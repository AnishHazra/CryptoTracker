//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 16/05/25.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = true  // animate right
    @State private var showPortfolioView: Bool = false  // new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false

    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(
                    isPresented: $showPortfolioView,
                    content: {
                        PortfolioView(isPresented: $showPortfolioView)
                            .presentationDragIndicator(.visible)
                            .environmentObject(vm)
                    }
                )

            // content layer
            VStack {
                HomeHeader

                HomeStatsView(showPortfolio: $showPortfolio)

                SearchBarView(searchText: $vm.searchText)

                columnTitles

                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
            .sheet(
                isPresented: $showSettingsView,
                content: {
                    SettingsView()
                        .presentationDragIndicator(.visible)
                }
            )

        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: {EmptyView()})
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {

    private var HomeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(nil, value: 0)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                    else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) {
                coin in
                CoinRowView(
                    coin: coin,
                    showHoldingsColumn: false
                )
                .listRowInsets(
                    .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                )
                .onTapGesture {
                    segue(coin: coin)
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            print("Pull Down")
            await vm.reloadData()
        }
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) {
                coin in
                CoinRowView(
                    coin: coin,
                    showHoldingsColumn: true
                )
                .listRowInsets(
                    .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                )
                .onTapGesture {
                    segue(coin: coin)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }

    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0: 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((
                                vm.sortOption == .holdings || vm.sortOption == .holdingsReversed
                            ) ? 1.0: 0.0
                        )
                        .rotationEffect(
                            Angle(degrees: vm.sortOption == .holdings ? 0 : 180)
                        )
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack{
                Text("Price")
                    .frame(
                        width: UIScreen.main.bounds.width / 3.5,
                        alignment: .trailing
                    )
                Image(systemName: "chevron.down")
                    .opacity(
                        (
                            vm.sortOption == .price || vm.sortOption == .priceReversed
                        ) ? 1.0: 0.0
                    )
                    .rotationEffect(
                        Angle(degrees: vm.sortOption == .price ? 0 : 180)
                    )
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
