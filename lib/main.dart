
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller1=TextEditingController();
  final TextEditingController controller2=TextEditingController();
  final List<String> _history=[];
  String result='';
   String _quote='Loading Quote';
  void _addNumber() {
    final int num1=int.tryParse(controller1.text) ??0;
    final int num2=int.tryParse(controller2.text) ??0;
    setState(() {
      result='${num1+num2}';
      _history.add('$num1 + $num2 = ${num1+num2}');
    });
  }

  Future<void> _fetchrandomquote()
  async{
   const String quoteurl='https://zenquotes.io/api/random';

    try{
      final response= await http.get(Uri.parse(quoteurl));
      if(response.statusCode==200)
        {
          final List<dynamic> quotes=jsonDecode(response.body);
            _quote=quotes[0]['q']+'-'+quotes[0]['a'];
            refresh();

        }
      else{
        apifail();
      }
    }
    catch(e)
    {
     apifail();
      print(e);
    }
  }

  void apifail()
  {
    setState(() {
      _quote='Failed to fetch';
    });
  }
  void refresh()
  {
    setState(() {});
  }

@override
void initState(){
    super.initState();
_fetchrandomquote();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Task 3"),
      ),
      body: Column(
        children: [
          const Center(child: Text("Quote of the Day",)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_quote,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          ),
          const Center(child: Text("Adder",style: TextStyle(fontWeight: FontWeight.bold),),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row
              (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                    controller: controller1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'First no.',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("+"),
                ),

                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                    controller: controller2,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Second no.',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        )
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("="),
                ),
                Text(result),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                  onPressed: _addNumber,
                  child: const Text("Add"),
                ),
              ),
              const Text("History :"),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _history.length,
                  itemBuilder: (context,index){
                    return Text(_history[index]);
                  }
              )
            ],
          ),

        ],
      ),
    );
  }
}
