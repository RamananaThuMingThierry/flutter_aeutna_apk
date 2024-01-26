import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OnLoadingPostShimmer extends StatelessWidget {
  const OnLoadingPostShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
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
                    child: Container(
                      color: Colors.grey,
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