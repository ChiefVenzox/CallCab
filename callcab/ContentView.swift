import SwiftUI
import MapKit // Harita için

// MARK: - Uygulama Ana Görünümü
struct ContentView: View {
    // Uygulamanın farklı ekranları arasında geçiş yapmak için bir seçim durumu
    @State private var selection: Int = 0

    var body: some View {
        // Sekmeli görünüm kullanarak ekranlar arasında geçiş yapma
        TabView(selection: $selection) {
            DestinationInputView()
                .tabItem {
                    Label("Hedef", systemImage: "mappin.and.ellipse")
                }
                .tag(0)

            VehicleSelectionView()
                .tabItem {
                    Label("Araç", systemImage: "car.fill")
                }
                .tag(1)

            DriverTrackingView()
                .tabItem {
                    Label("Takip", systemImage: "location.fill")
                }
                .tag(2)
        }
    }
}

// MARK: - 1. Hedef Giriş Ekranı
struct DestinationInputView: View {
    @State private var destination: String = "" // Hedef metin alanı
    @State private var recentLocations: [String] = ["123 Elm Street", "La Scala", "1500 Green Street", "210 Oakmont Drive"] // Son konumlar

    var body: some View {
        NavigationView { // Navigasyon çubuğu için
            VStack(alignment: .leading, spacing: 20) {
                Text("Hedefinizi Girin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                // Hedef giriş alanı
                TextField("Gideceğiniz yeri girin", text: $destination)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .padding(.horizontal)

                // Son aramalar bölümü
                Text("Son Aramalar")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 20)

                // Son konumları listeleyen ForEach döngüsü
                ForEach(recentLocations, id: \.self) { location in
                    HStack {
                        Image(systemName: "clock.fill") // Saat simgesi
                            .foregroundColor(.gray)
                        Text(location)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .onTapGesture {
                        self.destination = location // Konuma tıklandığında hedefi doldur
                    }
                }
                .padding(.horizontal)

                Spacer() // İçeriği yukarı itmek için

                // "Şimdi Rezervasyon Yap" butonu (şimdilik işlevsiz)
                Button(action: {
                    // Bu butona basıldığında araç seçim ekranına geçiş yapılabilir
                    print("Şimdi Rezervasyon Yap tıklandı")
                }) {
                    Text("Şimdi Rezervasyon Yap")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("") // Başlığı gizle
            .navigationBarHidden(true) // Navigasyon çubuğunu gizle
        }
    }
}

// MARK: - 2. Araç Seçim Ekranı
struct VehicleSelectionView: View {
    // Örnek araç tipleri
    let vehicleTypes = ["Ekonomi", "Konfor", "Aile", "Lüks", "SUV"]
    // Örnek fiyatlar
    let prices = ["₺120", "₺180", "₺250", "₺350", "₺300"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Bir Araç Seçin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                // Araç tiplerini yatay olarak kaydırılabilir bir görünümde göster
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<vehicleTypes.count, id: \.self) { index in
                            VehicleCard(type: vehicleTypes[index], price: prices[index])
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // "Şimdi Rezervasyon Yap" butonu
                Button(action: {
                    print("Şimdi Rezervasyon Yap tıklandı")
                }) {
                    Text("Şimdi Rezervasyon Yap")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

// Araç Seçim Ekranı için kart görünümü
struct VehicleCard: View {
    let type: String
    let price: String

    var body: some View {
        VStack {
            Image(systemName: "car.fill") // Araç simgesi
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding(.bottom, 5)

            Text(type)
                .font(.headline)
                .fontWeight(.semibold)

            Text(price)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 150, height: 180)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

// MARK: - 3. Sürücü Takip Ekranı
struct DriverTrackingView: View {
    // Harita bölgesi için örnek koordinatlar
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784), // İstanbul merkezi
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationView {
            VStack {
                // Harita görünümü
                Map(coordinateRegion: $region)
                    .edgesIgnoringSafeArea(.all) // Ekranın tamamını kapla

                // Sürücü bilgileri paneli
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sürücünüz 3 dakika içinde geliyor")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    HStack {
                        // Sürücü fotoğrafı (placeholder)
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))

                        VStack(alignment: .leading) {
                            Text("Alex Gendron")
                                .font(.headline)
                            Text("4.9 (230)") // Sürücü puanı
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Toyota Camry")
                                .font(.headline)
                            Text("ABC 123") // Plaka
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    // İletişim butonları
                    HStack(spacing: 20) {
                        Button(action: {
                            print("Mesaj gönder tıklandı")
                        }) {
                            Label("Mesaj", systemImage: "message.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            print("Ara tıklandı")
                        }) {
                            Label("Ara", systemImage: "phone.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

// Uygulamanın önizlemesi için
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
