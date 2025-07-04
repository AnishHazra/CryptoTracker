//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 23/06/25.
//

import SwiftUI

struct PortfolioView: View {

    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(
                content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        trailingNavBarButtons
                    }
                })
                .onChange(of: vm.searchText) {
                    if vm.searchText == "" {
                        removeSelectedCoin()
                    }
                }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(isPresented: .constant(false))
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {

    private var coinLogoList: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false,
            content: {
                LazyHStack(spacing: 10) {
                    ForEach(
                        vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins
                    ) { coin in
                        CoinLogoView(coin: coin)
                            .frame(width: 75)
                            .padding(4)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    updateSelectedCoin(coin: coin)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        selectedCoin?.id == coin.id
                                            ? Color.theme.green : Color.clear,
                                        lineWidth: 1
                                    )
                            )
                    }
                }
                .frame(height: 120)
                .padding(.leading)
            }
        )
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        }
        else {
            quantityText = ""
        }
    }

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text(
                    "Current price of \(selectedCoin?.symbol.uppercased() ?? ""):"
                )
                Spacer()
                Text(
                    selectedCoin?.currentPrice
                        .asCurrencyWith6Decimals()
                        ?? ""
                )
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(
                    getCurrentValue().asCurrencyWith6Decimals()
                )
            }
        }
        .animation(.none, value: 0)
        .padding()
        .font(.headline)
    }

    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Button(
                action: {
                    saveButtonPressed()
                },
                label: {
                    Text("Save")
                }
            )
            .opacity(
                (selectedCoin != nil
                    && selectedCoin?.currentHoldings
                        != Double(quantityText))
                    ? 1.0 : 0.0
            )
        }
        .font(.headline)
    }

    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    private func saveButtonPressed() {

        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }

        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)

        // hide keyboard
        DispatchQueue.main.async {
            UIApplication.shared.endEditing()
        }

        // close the sheet
        isPresented = false
        
        removeSelectedCoin()
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
