import 'dart:io';

import 'package:dbl_tenkaichi_budokai/gVar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'package:share/share.dart';

class MainTeamGen extends StatefulWidget {
  @override
  _MainTeamGenState createState() => _MainTeamGenState();
}

class _MainTeamGenState extends State<MainTeamGen> {
  Directory tpdr;String prepath;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currScreen=0;String tempIp="";int teamSize=1;
  List RowPanel=["Participants","Teams"];
  List PanelScreen=[];
  List ParticipantList=[],TeamList=[];

  @override
  void initState(){
    super.initState();
    dirpathget();
  }

  randomTeam(){
    if(teamSize==ParticipantList.length){
      setState(() {
        TeamList=[""];
        for(int i=0;i<ParticipantList.length;i++){
          TeamList[0]+=ParticipantList[i]+"\n";
        }
      });
    }else{
      List tempLst=[],tempTmlst=[];
      for(int i=0;i<ParticipantList.length;i++){
        tempLst.add(i);
        if(i%teamSize==0){
          tempTmlst.add("");
        }
      }
      int j=0,k;
      for(int i=0;i<ParticipantList.length;i++){
        k=Random().nextInt(ParticipantList.length);
        while(!tempLst.contains(k)){
          k=Random().nextInt(ParticipantList.length);
        }
        tempLst.remove(k);
        tempTmlst[j]+=ParticipantList[k];
        if((i+1)%teamSize==0){
          j++;
        }else{
          tempTmlst[j]+="\n";
        }
      }
      setState(() {
        TeamList=tempTmlst;
      });
    }
  }

  dirpathget()async{
    tpdr=await getExternalStorageDirectory();
    prepath=tpdr.toString().split("'")[1];
    print(prepath);
  }

  readParticipants()async{
    try{
      File file = await FilePicker.getFile();
      // remember version 1.4.2 only and minsdk 23
      List tl=(await file.readAsString()).split("\n");
      for(int i=0;i<tl.length;i++){
        tl[i]=tl[i].toUpperCase();
      }
      setState(() {
        ParticipantList.addAll(tl);
        Navigator.pop(context);
      });
    }catch(e){
      print(e);
    }
  }
  saveParticipants()async{
    try{
      String path='$prepath/ParticipantList.txt';
      File file = new File(path);
      await file.writeAsString(ParticipantList.join("\n"));
      return "Saved at $path";
    }catch(e){
      return "Error: $e";
    }

  }
  shareTeams()async{
    try{
      String path='$prepath/TeamList.txt';
      File file = new File(path);
      await file.writeAsString(TeamList.join("\n\n"));
      Share.shareFiles([path], text: 'Teams for the tournament');
    }catch(e){
      print(e);
    }
  }
  
  teamTag(i){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Rust,
                border: Border.all(width: 3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    text:TextSpan(
                      children: [
                        TextSpan(
                            text:"Team "+(i+1).toString()+"\n",
                          style: gStyle(32, FontWeight.bold, Gold,true),
                        ),
                        TextSpan(
                          text: TeamList[i],
                            style: gStyle(22, FontWeight.w300, AntiFlashWhite,false),
                        )
                      ]
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  RowPanelContainer(i){
    return Expanded(
      child: GestureDetector(
        onTap: (){
          setState(() {
            currScreen=i;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: AntiFlashWhite.withOpacity(0.7+(currScreen==i?0.3:0)),
              border: Border.all(),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                RowPanel[i],
                style: gStyle(22, FontWeight.w500, ChineseBlack,i==currScreen),
              ),
            ),
          ),
        ),
      ),
    );
  }

  nameTag(i){
    return Dismissible(
      key: GlobalKey(),
      direction: DismissDirection.horizontal,
      onDismissed: (direction){
        setState(() {
          ParticipantList.removeAt(i);
          teamSize=teamSize>ParticipantList.length?teamSize-1:teamSize;
          randomTeam();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AntiFlashWhite,
            border: Border.all(),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,width: 40,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                            FontAwesomeIcons.superpowers,size: 30,
                        ),
                      ),
                      Center(
                        child: Icon(
                            FontAwesomeIcons.grav,size: 21
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    ParticipantList[i],
                    style: gStyle(22, FontWeight.w300, ChineseBlack,false),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      ParticipantList.removeAt(i);
                      teamSize=teamSize>ParticipantList.length?teamSize-1:teamSize;
                      randomTeam();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                        FontAwesomeIcons.trash,color: Colors.redAccent,
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  inputDialog(){
    showDialog(
        context: context,
      builder: (context){
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 300,width:sw*0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 100,width:sw*0.9-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all()
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextField(
                            autofocus: true,
                            onSubmitted: (s){
                              setState(() {
                                if(tempIp!=""){
                                  ParticipantList.add(tempIp.toUpperCase());
                                }
                                tempIp="";
                                print(ParticipantList);
                                Navigator.pop(context);
                              });
                            },
                            cursorColor: ChineseBlack,
                            style: gStyle(25, FontWeight.w500, ChineseBlack, false),
                            onChanged: (s){
                              setState(() {
                                tempIp=s;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Center(
                      child: Text(
                          "OR",
                        style: gStyle(28, FontWeight.bold, ChineseBlack, false),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: GestureDetector(
                        onTap: (){
                          readParticipants();
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Gold,
                            border: Border.all(color: Tiger,width: 4),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Read File",
                              style: gStyle(28,FontWeight.w800, ChineseBlack, false),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      }
    );
  }

  addPanelScreen(){
      setState(() {
        PanelScreen=[
          Container(
            height: sh*0.9-200,
            child: ParticipantList.length==0?
            Center(
              child: Text(
                "Add Participants",
                style: gStyle(26, FontWeight.w500, ChineseBlack.withOpacity(0.5),false),
              ),
            ):
            ListView.builder(
              itemCount: ParticipantList.length,
              itemBuilder: (context,index){
                return nameTag(index);
              },
            ),
          ),
          Container(
            height: sh*0.9-200,
            child: ParticipantList.length==0?
            Center(
              child: Text(
                "No Participants",
                style: gStyle(26, FontWeight.w500, ChineseBlack.withOpacity(0.5),false),
              ),
            ):
            Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                "Team Size",
                                style: gStyle(26, FontWeight.w500, ChineseBlack.withOpacity(0.5),false),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              if(teamSize==1){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Center(
                                          child: Text(
                                            "Minimum Size is 1",
                                            style: gStyle(25, FontWeight.w500, Colors.redAccent, false),
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                "OK",
                                                style: gStyle(25, FontWeight.w500, ChineseBlack, false),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }else{
                                teamSize--;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,18,2,18),
                            child: Container(
                              height: 40,width:40,
                              decoration: BoxDecoration(
                                color: AntiFlashWhite,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(FontAwesomeIcons.minus),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,width: teamSize<100?40:null,
                          decoration: BoxDecoration(
                            color: Rust,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              teamSize.toString(),
                              style: gStyle(26, FontWeight.w500, AntiFlashWhite,false),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              if(teamSize+1>ParticipantList.length){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Center(
                                          child: Text(
                                            "Not Enough Participants",
                                            style: gStyle(25, FontWeight.w500, Colors.redAccent, false),
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Center(
                                              child: Text(
                                                "OK",
                                                style: gStyle(25, FontWeight.w500, ChineseBlack, false),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }else{
                                teamSize++;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2,18,18,18),
                            child: Container(
                              height: 40,width:40,
                              decoration: BoxDecoration(
                                color: AntiFlashWhite,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(FontAwesomeIcons.plus),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TeamList.length==0?Container():
                        SingleChildScrollView(
                          child: Container(
                            height: sh*0.9-280,
                            child: ListView.builder(
                                itemCount: TeamList.length,
                                itemBuilder: (context,index){
                                  return teamTag(index);
                                }
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ];
      });
  }

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    addPanelScreen();
    if(teamSize<1){
      teamSize=1;
    }
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Gold,
          appBar: AppBar(
            backgroundColor: Tiger,
            shadowColor: Rust,
            elevation: 30,
            toolbarHeight: 100,
            centerTitle: true,
            title: Text(
              "TEAM GENERATOR",
              style: gStyle(26, FontWeight.w500, ChineseBlack,false),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: ()async{
                    if(currScreen==1 && TeamList.length>0){
                      shareTeams();
                    }
                    if(currScreen==0 && ParticipantList.length>0){
                      var x=await saveParticipants();
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              x.toString(),
                              style: gStyle(18, FontWeight.w100, ChineseBlack, false),
                            ),
                            backgroundColor: x.toString().contains("Error")?Colors.redAccent:Colors.lightGreenAccent,
                            duration: Duration(seconds: 5),
                          )
                      );
                    }
                  },
                  child: Icon(
                    FontAwesomeIcons.locationArrow,
                    size: 25,color: ChineseBlack,
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              currScreen==0?inputDialog():randomTeam();
            },
            backgroundColor: Tiger,
            elevation: 10,
            child: currScreen==0?Icon(FontAwesomeIcons.plus):Icon(FontAwesomeIcons.rocket),
          ),
          body:SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    RowPanelContainer(0),
                    RowPanelContainer(1)
                  ],
                ),
                PanelScreen[currScreen],
              ],
            ),
          ),
        )
    );
  }
}
