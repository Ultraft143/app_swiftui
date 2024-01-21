import SwiftUI
import UserNotifications


struct login: View {
    
    
    
    @State private var username: String = "";
    
    @State private var password: String = "";
    
    @State private var isPasswordVisible: Bool = false;
    
    @State private var showAlert: Bool = false;
    
    @State public var alertuser = false;
    
    let URL_CREATE_USER = "\(API)/getuser.php"
    
    
    var body: some View {
        NavigationView{
            ZStack {
                
                Color(.orange).ignoresSafeArea();
                
                
                
                Circle()
                
                    .scale(1.7)
                
                    .foregroundColor(.white.opacity(0.15))
                
                Circle()
                
                    .scale(1.3)
                
                    .foregroundColor(.white)
                
                
                
                VStack {
                    
                    VStack {
                        
                        Image(systemName:"helm")
                        
                            .resizable()
                        
                            .aspectRatio(contentMode: .fit)
                        
                            .frame(width: 130, height: 700)
                        
                            .offset(x:0, y:-25)
                        
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        
                        
                        Text("Projeto")
                        
                            .foregroundColor(.black)
                        
                            .bold()
                        
                            .font(.system(size: 56))
                        
                            .offset(x:0,y:-325)
                        
                    }
                    
                    
                    
                    VStack {
                        
                        
                        
                        VStack {
                            
                            TextField ("Nome de Usuário", text: $username)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x:0,y:-345)
                            
                            Rectangle()
                            
                                .frame(width: 300, height: 1)
                            
                                .offset(x:0,y:-345)
                            
                            
                            
                        } .padding()
                        
                        VStack {
                            
                            
                            
                            HStack {
                                
                                
                                
                                if isPasswordVisible {
                                    
                                    TextField("Password", text: $password)
                                    
                                        .padding()
                                    
                                        .frame(width: 300, height: 50)
                                    
                                        .background(Color.black.opacity(0.05))
                                    
                                        .cornerRadius(10)
                                    
                                        .offset(x:15, y: -330)
                                    
                                    
                                    
                                } else {
                                    
                                    SecureField("Password", text: $password)
                                    
                                        .padding()
                                    
                                        .frame(width: 300, height: 50)
                                    
                                        .background(Color.black.opacity(0.05))
                                    
                                        .cornerRadius(10)
                                    
                                        .offset(x: 15, y: -330)
                                    
                                }
                                
                                
                                
                                Button(action: {
                                    
                                    isPasswordVisible.toggle()
                                    
                                    
                                    
                                }) {
                                    
                                    Text(isPasswordVisible ? "🔓" : "🔐")
                                    
                                    
                                    
                                }
                                
                                .offset(x: 15, y: -330)
                                
                            }
                            
                        }
                        
                        
                        
                        .padding()
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Rectangle()
                        
                            .frame(width: 300, height: 1)
                        
                            .offset(x:0,y:-345)
                        
                    } .padding()
                    
                    Spacer ()
                    
                        .frame(width: 1, height: 10)
                    
                    
                    
                    Button (action: {
                        
                        //created NSURL
                        let requestURL = URL(string: URL_CREATE_USER)
                        
                        //creating NSMutableURLRequest
                        let request = NSMutableURLRequest(url: requestURL! as URL)
                        
                        //setting the method to post
                        request.httpMethod = "POST"
                        
                        //creating the post parameter by concatenating the keys and values from text field
                        let postParameters = "user_name=\($username.wrappedValue)&user_password=\($password.wrappedValue)"
                        
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
                                            if(jsonResponse["error"] as! Int == 0){
                                                UserLoged = 1
                                                UserID = jsonResponse["id"] as! Int
                                                alertuser = true
                                            }
                                            else{
                                                alertuser = false
                                            }
                                            showAlert = true
                                        } else {
                                            print("Error: JSON parsing failed.")
                                            alertuser = false
                                            showAlert = true
                                        }
                                    } catch {
                                        print("Error: JSON serialization failed.")
                                        alertuser = false
                                        showAlert = true
                                    }
                                    
                                })
                                
                            })
                        
                        
                        
                        task.resume()
                        
                        
                    }) {
                        
                        
                        
                        Text ("Finalizar")
                        
                            .font(.callout)
                        
                            .foregroundColor(.white)
                        
                            .frame(width: 200, height: 28)
                        
                            .background (Color.black.opacity(0.80))
                        
                            .cornerRadius(30)
                        
                    }
                    .alert(isPresented: $showAlert, content: {
                        if(alertuser == true){
                            Alert(title: Text("Sucesso!"), message: Text("O Login foi finalizado com sucesso."))
                        }else{
                            Alert(title: Text("Erro!"), message: Text("Nao foi possivel executar o Login."))
                        }
                    })
                    .offset(x:0,y:-345)
                    
                    
                    
                    NavigationLink (destination: registo()) {
                        Text ("Não possui uma conta?")
                            .font(.callout)
                            .foregroundColor(.black)
                    }
                    .offset(x:0,y:-345)
                    
                    
                    
                }
                
            }
        }
        
    }
    
    
}

#Preview {
    
    login()
    
}
