import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My APP',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 10, 10, 10)
      ),
      home: const MyHomePage(title: 'Social'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});




  final String title;
   
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: Text(
          'Social',
    style:TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontFamily:'sans-serif'

    ),             ),
      ),
      body: ListView(

        children:[
          Column(
            children: [
              Card(
                margin: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: 10,
                  right: 0,
                ),
                  child:Container(
                    color: Color.fromARGB(255,10 ,10 ,10),
                    child:
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Friends',
                      style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                      SizedBox(width: 30),
                      Row(mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text('Messages',
                        style:TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white, 

                        ),),
                        SizedBox(width: 30),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Requests',
                        style:TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.normal,
                          color:Colors.white,  
                        
                        ),
                      )
                    ],

                  )

                ],
                   )
           ],)
                    
                  )

                ),          
                
            ],

          ),
        ]
      )
    );
  }
}