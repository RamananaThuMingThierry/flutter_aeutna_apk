import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OnLoadingMembreShimmer extends StatelessWidget {
  const OnLoadingMembreShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context,int index){
          return Shimmer.fromColors(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                      ),
                      title: Row(
                        children: [
                          Container(
                            height: 15,
                            width: 40,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            height: 15,
                            width: 200,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!
          );
        });
  }
}