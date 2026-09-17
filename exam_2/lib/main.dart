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
String friends = "Friends";
String messages = "Messages";
String requests = "Requests";
String search = "Search";
String valorant = "VALORANT";
String onlinevaorant = "Online-VALORANT";
String missyoulikekrazy = "MissYouLikeKrazy";
String bread = "bread";
String the14th = "The14th";
String online = "Online";

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
                   ),
                   Card( 
                    margin: EdgeInsets.only(top: 1, bottom: 0, right: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
                    color: Colors.black,
                    child: Padding(padding: EdgeInsetsGeometry.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      child: Padding(padding: 
                      EdgeInsetsGeometry.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 30,
                          color: Colors.white,),
                          SizedBox(width: 5,),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white54,
                              fontFamily: 'sans-serif'
                            ),
                          )
                        ],
                      ),
                    )
                    )
                   ),
                  ),

                  Card(
                    color: Colors.black,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
                    child: Padding(padding: EdgeInsetsGeometry.only(
                      top: 0,
                      bottom: 16,
                      left: 25,
                      right: 16, ),
                      child: Row(
                        children: [
                          Icon(Icons.circle_rounded,
                          size: 30,
                          color: Colors.redAccent,),
                          SizedBox(width: 10,),
                          Text(
                            'VALORANT',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'sans-serif',
                              fontWeight: FontWeight.bold, 
                              color: Colors.white70,
                            ),),
                            SizedBox(width: 10),
                            Text('3',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'sans-serif',
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),),
                            Card(
                              color:Colors.black,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child: Padding(padding: 
                              EdgeInsetsGeometry.only(
                                top : 0,
                                bottom: 16,
                                left: 30,
                                right: 16),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                          radius: 25,
                                          child: Icon(Icons.person,
                                          color: Colors.redAccent,
                                          size: 40,),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.circle,
                                        size: 15,
                                        color: Colors.black,),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(width: 10,),
                                        Icon(Icons.circle,
                                        size:15,
                                        color: Colors.greenAccent,),
                                      ],
                                    ),
                                    SizedBox( width: 10,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'MissYouLikeKrazy',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'sans-serif',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),),
                                          SizedBox( height: 5,),
                                          Row(children: [
                                              Icon(Icons.monitor,
                                              size: 15,
                                              color: Colors.white54,),
                                          ],), 
                                          SizedBox( width: 1),
                                          Text(
                                            'Online - VALORANT',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'sans-serif',
                                              color: Colors.white60,

                                            ),),

                                      ],
                                    )
                                  ],
                                  
                                ),
                                
                              )
                            ),
                            Card(
                              color: Colors.black,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child: Padding(padding: EdgeInsetsGeometry.only(
                                top: 0,
                                bottom: 16,
                                left: 30,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:Color.fromARGB(255,20,20,20),
                                        radius: 20,
                                        child: Icon(Icons.person, 
                                        size: 40 ,
                                        color:Colors.redAccent),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                          size: 15,
                                          color:Colors.black,),
                                          SizedBox(width:10),
                                          Icon(Icons.play_circle,
                                          size: 15,
                                          color: Colors.lightBlueAccent),

                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),)
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                Text('bread',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'sans-serif',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.monitor,
                                    size: 15,
                                    color:Colors.white10,),
                                    SizedBox(width: 1),

                                    Text('Playing - VALORANT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'sans-serif',
                                      color: Colors.white,
                                    ))
                                    
                                  ],
                                )
                              ],
                            )
                        ],
                      ))
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