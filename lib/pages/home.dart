
import 'dart:io';

import 'package:band_name/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    new Band(id:'1', name:'Metalica', votes: 2),
    new Band(id:'2', name:'Boys2', votes: 10),
    new Band(id:'3', name:'Mana', votes: 3),
    new Band(id:'4', name:'Van Van', votes: 7),
    new Band(id:'5', name:'R Kelly', votes: 8),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body:ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index)  
          => _bandTile(bands[index])
        ,),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 1,
          onPressed: addNewBand),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction){
        print('direction: $direction');
        print('id: ${band.id}');

         //TODO LLAMAS AL BORADO DEL SERVER
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band'),
        ),
        
        ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ), 
            title: Text(band.name),
            trailing: Text('${band.name}', style: TextStyle(fontSize: 20),),
            onTap:(){
              print(band.name);
            } 
          ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if(Platform.isAndroid)
      showDialog(
       context: context,
       builder: (context){
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
               MaterialButton(
                 child: Text('Add'),
                 elevation: 5,
                 textColor: Colors.blue,
                 onPressed: ()=> addBandToList(textController.text))
            ],
          );
       } );

    if(Platform.isIOS)
       showCupertinoDialog(
         context: context,
         builder: ( _ ){
           return CupertinoAlertDialog(
             title: Text('New band name:'),
             content: CupertinoTextField(
               controller: textController,
             ),
             actions: <Widget>[
               CupertinoDialogAction(
                 isDestructiveAction: true,
                 child: Text('Add'),
                 onPressed: ()=> addBandToList(textController.text),
               ),
               CupertinoDialogAction(
                 isDestructiveAction: true,
                 child: Text('Dismiss'),
                 onPressed: ()=> Navigator.pop(context),
               )
             ],
           );
         }
       
       );
    
  }

  void addBandToList(String nameBand){

        if(nameBand.length > 1){
          this.bands.add(new Band(id: DateTime.now().toString(), name: nameBand, votes: 0));
         setState(() {
           
         });
        }

        Navigator.pop(context);
  }
}