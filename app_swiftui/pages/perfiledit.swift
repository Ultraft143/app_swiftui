import SwiftUI

struct perfiledit: View {
    
    @State private var username: String = "";
    @State private var password: String = "";
    @State private var email: String = "";
    @State private var checkM: Bool = false
    @State private var checkF: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert: Bool = false;
    
    @State public var alertuser = false;
    
    @State public var alertmessage: String = ""
    
    let URL_GETUSERBYID = "\(API)/getUserbyID.php"
    
    let URL_UPDATEUSER = "\(API)/updateuser.php"
    
    var body: some View {
        
        ZStack {
            Color(.lightGray).ignoresSafeArea();
            
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.3)
                .foregroundColor(.white)
            
            ZStack
            {
                
                ZStack
                {
                    
                    Image(systemName:"person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 700)
                        .offset(x: 0, y: -300)
                        .padding(22)
                    
                }
                
                
                ZStack
                {
                    
                    Text("Perfil")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 45))
                        .offset(x: 0, y: -200)
                    
                }
                
                TextField ("username", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .offset(x: 0 ,y: -70)
                
                
                TextField ("email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .offset(x: 0, y: 15)
                
                
                ZStack {
                    
                    
                    
                    ZStack {
                        
                        
                        
                        if isPasswordVisible {
                            
                            TextField("Password", text: $password)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x: 0, y: 100)
                            
                            
                            
                        } else {
                            
                            SecureField("Password", text: $password)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x: 0, y: 100)
                            
                        }
                        
                        
                        
                        ZStack{ Button(action: {
                            
                            isPasswordVisible.toggle()
                            
                            
                            
                        }) {
                            
                            Text(isPasswordVisible ? "🔓" : "🔐")
                            
                            
                            
                            
                        }
                        }.offset(x: 170, y: 100)
                        
                        Button (action: {
                            
                            //created NSURL
                            let requestURL = URL(string: URL_UPDATEUSER)
                            
                            //creating NSMutableURLRequest
                            let request = NSMutableURLRequest(url: requestURL! as URL)
                            
                            //setting the method to post
                            request.httpMethod = "POST"
                            
                            //creating the post parameter by concatenating the keys and values from text field
                            let postParameters = "changeID=\(UserID)&user_email=\($email    .wrappedValue)&user_name=\($username.wrappedValue)&user_password=\($password.wrappedValue)"
                            
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
                                                    alertuser = true
                                                    alertmessage = jsonResponse["message"] as! String
                                                }
                                                else{
                                                    alertuser = false
                                                    alertmessage = jsonResponse["message"] as! String
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
                        .offset(x:0,y:180)
                        .alert(isPresented: $showAlert, content: {
                            if(alertuser == true){
                                if(alertmessage != ""){
                                    Alert(title: Text("Sucesso!"), message: Text("\(alertmessage)"))
                                }
                                else{
                                    Alert(title: Text("Sucesso!"), message: Text("As alteracoes foram guardadas com sucesso."))
                                }
                            }else{
                                if(alertmessage != ""){
                                    Alert(title: Text("Erro!"), message: Text("\(alertmessage)"))
                                }
                                else{
                                    Alert(title: Text("Erro!"), message: Text("Nao foi possivel guardar as alteracoes."))
                                }
                            }
                        })
                    }
                }
            }
            .onAppear(perform: {
                
                //created NSURL
                let requestURL = URL(string: URL_GETUSERBYID)
                
                //creating NSMutableURLRequest
                let request = NSMutableURLRequest(url: requestURL! as URL)
                
                //setting the method to post
                request.httpMethod = "POST"
                
                //creating the post parameter by concatenating the keys and values from text field
                let postParameters = "user_id=\(UserID)"
                
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
                                    //print(UserID)
                                    if(UserID == 0){
                                        username = "Erro!"
                                        email = "Nao foi possivel encontrar o utilizador"
                                        password = ""
                                    }else if(jsonResponse["user_name"] as! String != ""){
                                        username = jsonResponse["user_name"] as! String
                                        email = jsonResponse["user_email"] as! String
                                        password = jsonResponse["user_password"] as! String
                                        
                                    }
                                    
                                } else {
                                    print("Error: JSON parsing failed.")
                                }
                            } catch {
                                print("Error: JSON serialization failed.")
                            }
                            
                        })
                        
                    })
                
                
                
                task.resume()
                
            })
            
        }
    }
}
#Preview {
    perfiledit()
}
