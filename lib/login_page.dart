import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nss_project/signup_page.dart';

final enableborder=OutlineInputBorder(
  borderSide:const BorderSide(width:3,color:Color.fromARGB(255, 175, 178, 175)),
  borderRadius:BorderRadius.circular(12)
);

final focusborder=OutlineInputBorder(
  borderSide:const BorderSide(width:3,color:Colors.blue),
  borderRadius:BorderRadius.circular(12)
);

class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
    State createState()
    {
      return LoginPageState();
    }
}

class LoginPageState extends State<LoginPage>
{
  TextEditingController emailinput=TextEditingController();
  TextEditingController passwordinput=TextEditingController();

  bool _visibility=false;
  var passwordicon=Icons.visibility;

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _trySignIn() async {
    if (_isLoading) {
      return;
    }

    if (emailinput.text.trim() == '' || passwordinput.text.trim() == '') {
      setState(() => _errorMessage = 'Can\'t leave one or more fields empty.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(email:emailinput.text.trim(), password: passwordinput.text.trim());

      FocusManager.instance.primaryFocus?.unfocus(); // TODO Doesn't work

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.message!;
      });
    }
  }

  @override
  void dispose()
  {
    super.dispose();
    emailinput.dispose();
    passwordinput.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      body:TweenAnimationBuilder(
        tween:Tween<double>(begin: 0,end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Opacity(opacity: value,child: child,);
              },
        child: SingleChildScrollView(
            padding:EdgeInsets.fromLTRB(0, height/10, 0, 0),
            child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            SizedBox(
              width:400,
              height:300,
              child:Image.asset('assets/images/nss-iitp-logo.png')
            ),
        
            Padding( padding:EdgeInsets.fromLTRB(0,20,width*0.45,20),
            child:const Text('Welcome!',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900))
            ),
        
            Padding( 
              padding:EdgeInsets.fromLTRB(width/10,0,width/10,0),
              child:TextField(
                controller:emailinput,
                decoration: InputDecoration(
                enabledBorder: enableborder,
                focusedBorder: focusborder,
                labelText:'Enter Email',
              ),
            )
            ),
        
             Padding( 
              padding:EdgeInsets.fromLTRB(width/10,20,width/10,0),
              child:TextField(
                obscuringCharacter: '*',
                obscureText: !_visibility,
                controller:passwordinput,
                decoration: InputDecoration(
                suffixIcon:IconButton(
                  icon:Icon(passwordicon),
                  onPressed:()=>{setState((){
                    if(_visibility==false)
                     {
                    _visibility=true;
                    passwordicon=Icons.visibility_off;
                     }
                    else
                    {
                      _visibility=false;
                      passwordicon=Icons.visibility;
                    }
                    }
                   )
                 },
        
                ),
                enabledBorder: enableborder,
                focusedBorder: focusborder,
                labelText:'Enter Password',
              ),
            )
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(
                width:width/3,
                height:50,
                child:TextButton(
                  onPressed: _trySignIn,
                  style:const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                    foregroundColor:WidgetStatePropertyAll(Colors.white),
                  ),
                  child: (_isLoading ? CircularProgressIndicator(color: Colors.white) : const Text('Submit')),
                )
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(child: Center(child: Text((_isLoading ? '' : _errorMessage), style: TextStyle(color: Colors.red))), width: 3 * width / 4),
            ),
        
             Padding(
               padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
               child: Row(mainAxisAlignment: MainAxisAlignment.center,
               children: [const Text('Don\'t have an account? '),GestureDetector(onTap:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));},child: const Text('Sign Up',style:TextStyle(color:Colors.blue)))],),
             )
            ]
          )
        ),
      ),
     )
;
  }

}
