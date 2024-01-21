import SwiftUI

struct Detalhes: View {
    @State var articles: [String] = Array(repeating: "", count: 10)
    @State private var descricao: String = "";
    @State private var presencas: String = "";
    let URL_GET_TRACKBYID = "\(API)/getTrackbyid.php"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.lightGray).ignoresSafeArea()
                
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.3)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Sessão")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 40))
                        .offset(x: 20, y: -15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(0..<articles.count, id: \.self) { index in
                                TextField("Artigo \(index + 1):", text: $articles[index])
                                    .padding()
                                    .frame(width: 350, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                        
                                    )
                            }
                        }
                        
                    }
                    .offset(x:0,y:-30)
                    VStack{
                        Text("Presenças -->")
                            .bold()
                            .offset(x:-110 , y: 0)
                            .padding()
                        TextField ("", text: $presencas)
                            .padding()
                            .disabled(true)
                            .font(.callout)
                            .foregroundColor(.black)
                            .frame(width: 200, height: 50)
                            .background(Color.black.opacity(0.05))
                            .border(Color.black)
                            .offset(x:60,y:-55)
                        
                        
                        
                    }
                    
                    VStack{
                        Text("Descrição da sessão:")
                            .bold()
                            .offset(CGSize(width: -70, height: -50.0))
                            .padding()
                            .offset(x:-10,y:-20)
                        
                        ScrollView {
                            TextEditor(text: $descricao)
                                .frame(width: 340, height: 1000)
                                .background(Color.black.opacity(0.05))
                                .disabled(true)
                        }
                        .frame(height:200)
                        .border(.black)
                        .offset(x:0,y:-80)
                        
                        NavigationLink(destination: presença())
                        {
                                Text("Confirmar presença")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 30)
                                    .background(Color.black.opacity(0.80))
                                    .cornerRadius(30)
                        }
                        .offset(x:0,y:-50)
                        NavigationLink(destination: geralquestoes())
                        {
                                Text("❔Questões de outros usuários❔")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 30)
                                    .background(Color.black.opacity(0.80))
                                    .cornerRadius(30)
                        }
                        .offset(x:0,y:-40)
                        NavigationLink(destination: ficheiros())
                        {
                                Text("🗂Ficheiros🗂")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 30)
                                    .background(Color.black.opacity(0.80))
                                    .cornerRadius(30)
                        }
                        .offset(x:0,y:-25)
                        if(UserLoged == 0){
                            NavigationLink(destination: questao())
                            {
                                    Text("Colocar questões ao autor")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .frame(width: 300, height: 30)
                                        .background(Color.black.opacity(0.80))
                                        .cornerRadius(30)
                                        
                            }
                            .disabled(true)
                            .offset(x:0,y:-10)
                        }
                        else{
                            NavigationLink(destination: questao())
                            {
                                    Text("Colocar questões ao autor")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .frame(width: 300, height: 30)
                                        .background(Color.black.opacity(0.80))
                                        .cornerRadius(30)
                            }
                            .offset(x:0,y:-10)
                        }

                    }
                }
                .onAppear(perform: {
                    loadData()
                })
            }
        }
        
    }
    
    func loadData() {
        //created NSURL
        let requestURL = URL(string: URL_GET_TRACKBYID)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "id=\(TrackPicked)"
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(
            with: request as URLRequest,
            completionHandler: { data, response, error in
                DispatchQueue.main.async(execute:{
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            print("JSON response: \(jsonResponse)")

                            if let titles = jsonResponse["titulo"] as? String {
                                articles = titles.components(separatedBy: ",")
                            } else {
                                print("Error: Unable to retrieve titles from JSON response.")
                            }
                            descricao = jsonResponse["texto"] as! String
                            presencas = jsonResponse["empresa"] as! String
                            
                        } else {
                            print("Error: JSON parsing failed.")
                        }
                    } catch {
                        print("Error: JSON serialization failed.")
                    }
                    
                })
                
            })
        
        
        
        task.resume()
    }
}
#Preview {
    Detalhes()
}
