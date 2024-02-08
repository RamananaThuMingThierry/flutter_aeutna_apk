import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/screens/admin/class/Pages.dart';
import 'package:aeutna/screens/admin/class/Sections.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({Key? key}) : super(key: key);

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {

  List<Map<String, dynamic>> data = [];

  Future _statistiques() async{
    ApiResponse apiResponse = await statistiquesMembres();
    if(apiResponse.error == null){
      setState(() {
        // Ajoutez les nouveaux éléments à la liste existante
        data.addAll((apiResponse.data as Iterable).cast<Map<String, dynamic>>());
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  @override
  void initState() {
    _statistiques();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        title: TitreText("Statistiques"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.area_chart, color: Colors.blueGrey,)
          )
        ],
      ),
      body:  data == null || data.isEmpty
          ? Center(
              child: SpinKitCircle(
                color: Colors.blueGrey,
              ),
            )
          : Center(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: Border(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("${data![0].keys.first}", style: style_google.copyWith(fontWeight: FontWeight.bold),),
                          Text("${data![0].values.first}", style: style_google.copyWith(color: Colors.grey, fontSize: 30),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: data.length -1,
                  itemBuilder: (BuildContext context,int index){
                    String nom = data[index + 1].keys.first;
                    int nombre = data[index + 1].values.first;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                      child: Card(
                        shape: Border(),
                        elevation: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${nombre}", style: style_google.copyWith(color: Colors.grey, fontSize: 40),),
                            Text("${nom}", style: style_google.copyWith(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
