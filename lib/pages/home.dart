
import 'dart:io';

import 'package:band_name/models/band.dart';
import 'package:band_name/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = []; /*= [
    new Band(id:'1', name:'Metalica', votes: 2),
    new Band(id:'2', name:'Boys2', votes: 10),
    new Band(id:'3', name:'Mana', votes: 3),
    new Band(id:'4', name:'Van Van', votes: 7),
    new Band(id:'5', name:'R Kelly', votes: 8),

  ];*/

  /*@override
  void initState() {
    // TODO: implement initState
    final socketService = Provider.of<SocketService>(context, listen: false);

   socketService.socket.on('active-bands', (data) {     
    this.bands =  (data as List).
         map((band) => Band.fronMap(band))
         .toList();   
    //print(data);
    setState(() {
      
    });
   });
    super.initState();
  } */

    @override
  void initState() {
    
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload ) {

    this.bands = (payload as List)
        .map( (band) => Band.fronMap(band) )
        .toList();

    setState(() {});
  }

  /*@override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-bands');
    super.dispose();
  }*/


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: 
            //Icon(Icons.check_circle, color: Colors.blue[300],),
            socketService.serverStatus == ServerStatus.Online ? Icon(Icons.check_circle, color: Colors.blue[300],) : Icon(Icons.offline_bolt, color: Colors.red[300],),
            )
        ],
      ),
      body: Column(children: <Widget>[

        _showGraph(), 
        
                Expanded(
                 child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (BuildContext context, int index)  
                    => _bandTile(bands[index])
                  ,),
                )
              ],),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  elevation: 1,
                  onPressed: addNewBand),
           );
          }
        
          Widget _bandTile(Band band) {
            final socketService = Provider.of<SocketService>(context, listen: false);
            return Dismissible(
              key: Key(band.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction){
                print('direction: $direction');
                print('id: ${band.id}');
                socketService.socket.emit('delete-band', {'id': band.id});
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
                    trailing: Text('${band.votes}', style: TextStyle(fontSize: 20),),
                    onTap: () {
                      socketService.socket.emit('vote-band', { 'id': band.id } ) ;
                      print('object :' + band.id );
                    } ,
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
            final socketService = Provider.of<SocketService>(context, listen: false);
        
                if(nameBand.length > 1){
                  socketService.socket.emit('add-band', {'name': nameBand});
                  //this.bands.add(new Band(id: DateTime.now().toString(), name: nameBand, votes: 0));
                }
        
                Navigator.pop(context);
          }
        
       Widget _showGraph() {
            Map<String, double> dataMap =  new Map();
            /*dataMap.putIfAbsent('Flutter', () => 5);
            dataMap.putIfAbsent('React', () => 3); 
            dataMap.putIfAbsent('Xamarin', () =>2);
            dataMap.putIfAbsent('Ionic', () => 2);*/
            
            this.bands.forEach((element) { 
              dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
            });
            final List<Color> colorList = [
               Colors.blue[400],
               Colors.green[300],
               Colors.yellow[400],
               Colors.orange[400],
               Colors.purple[300],
               Colors.red[400],

              ];
            return Container(
              width: double.infinity,
              height: 200,
              child: PieChart(      dataMap: dataMap,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 2.2,
                          colorList: colorList,
                          initialAngleInDegree: 0,
                          chartType: ChartType.disc,
                          ringStrokeWidth: 32,
                          centerText: "Bandas",
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.rectangle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                          ))
                        );
            //dataMap.putIfAbsent('Flutter', () => 5);
          }
}