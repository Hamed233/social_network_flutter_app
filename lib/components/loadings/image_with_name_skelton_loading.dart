import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ImageWithNameSkeletonLoading extends StatefulWidget {
  const ImageWithNameSkeletonLoading({ Key? key }) : super(key: key);

  @override
  _ImageWithNameSkeletonLoadingState createState() => _ImageWithNameSkeletonLoadingState();
}

class _ImageWithNameSkeletonLoadingState extends State<ImageWithNameSkeletonLoading> {  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (BuildContext ctx, index) {
        int timer = 1000;
        return  Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            period: Duration(milliseconds: timer),
            child: box(),
        );
      }
    );
  }


  Widget box(){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                  width: 150,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 15,),
          Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }
}