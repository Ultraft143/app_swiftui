import SwiftUI

struct geralquestoes: View {
    @State private var selectedTab: Tab?
    @State private var goqdetahes = false
    @Environment (\.colorScheme) private var scheme
    @State private var tabProgress: CGFloat = 1
    @State private var models: [PerguntasModel] = []
    
    let URL_GETPERGUNTAS = "\(API)/getPerguntas.php"

    
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                Button (action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                Spacer()
                
                Button (action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
            }
            .font(.title2)
            .overlay {
                Text("Detalhes")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            CustomTabBar()
            
            
            
            GeometryReader{
                let size = $0.size
                
                
                    LazyHStack(spacing: 0){
                    
                        
                        SampleView(.red)
                            .id(Tab.questoes)
                            .containerRelativeFrame(.horizontal)
                        
                      
                    }
                    .scrollTargetLayout()
                    .offsetX { value in
                        
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        
                        tabProgress = max(min(progress, 1), 0)
                    }
                
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.gray.opacity(0.1))
    }
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack (spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10){
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture{
                    withAnimation(.snappy){
                        selectedTab = tab
                    }
                    
                }
            }
        }
        .tabMask(tabProgress)
        
        .background(){
            GeometryReader{
                let size = $0.size
                let capusleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capusleWidth)
                    .offset(x:tabProgress * (size.width - capusleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        NavigationView{
            ScrollView(.vertical){
                LazyVGrid(columns: Array(repeating: GridItem(),count: 2), content: {
                    ForEach(self.models) { (model) in
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(color.gradient)
                                    .frame(height: 150)
                                
                                Text(model.pergunta ?? "")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                            }
                            .onTapGesture {
                                PerguntaID = model.id!
                                print(PerguntaID)
                                goqdetahes = true
                            }
                         
                        

                        
                    }
                    
                })
                .padding(15)
                NavigationLink(destination: qdetalhe(), isActive: $goqdetahes) {
                }
                .hidden()
            }
            .onAppear(perform: {
                loadData()
            })
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .mask {
                Rectangle()
                    .padding(.bottom, -100)
            }
        }
        
    }
    
    func loadData() {
        guard let url: URL = URL(string: URL_GETPERGUNTAS) else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                print("invalid response")
                return
            }
            
            do {
                self.models = try JSONDecoder().decode([PerguntasModel].self, from: data)
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}

struct PerguntasModel: Codable, Identifiable {
    var id: String? = ""
    var nome: String? = ""
    var email: String? = ""
    var pergunta: String? = ""
}

#Preview {
    geralquestoes()
}
