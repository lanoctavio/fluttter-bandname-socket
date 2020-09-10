

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Conneting}

  /*const List EVENTS = [
  'connect',
  'connect_error',
  'connect_timeout',
  'connecting',
  'disconnect',
  'error',
  'reconnect',
  'reconnect_attempt',
  'reconnect_failed',
  'reconnect_error',
  'reconnecting',
  'ping',
  'pong'
];*/

class SocketService with ChangeNotifier{

    ServerStatus _serverStatus = ServerStatus.Conneting;
    IO.Socket _socket;
    ServerStatus get serverStatus => this._serverStatus;
    IO.Socket get socket => this._socket;

    SocketService(){
      this._initConfig();
    }

    void _initConfig(){

          // Dart client
        this._socket = IO.io('http://192.168.0.4:3000',<String, dynamic>{
          'transports'   :['websocket'],
          'autoConnect' : true,
        });
        this._socket.on('connect', (_) {
          this._serverStatus = ServerStatus.Online;
          notifyListeners();
        //socket.emit('msg', 'test');
        });
        //socket.on('event', (data) => print(data));
        this._socket.on('disconnect', (_) {
            this._serverStatus = ServerStatus.Offline;
            notifyListeners();
    
        });

        /* socket.on('nuevo-mensaje', (payload) {
            print('nuevo mensaje $payload');
            //notifyListeners();    
        });*/
        //socket.on('fromServer', (_) => print(_));`

    }
}