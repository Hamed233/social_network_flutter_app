import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PollPostSkeletonLoading extends StatefulWidget {
  const PollPostSkeletonLoading({Key? key}) : super(key: key);

  @override
  _PollPostSkeletonLoadingState createState() =>
      _PollPostSkeletonLoadingState();
}

class _PollPostSkeletonLoadingState extends State<PollPostSkeletonLoading> {
  @override
  Widget build(BuildContext context) {
    int timer = 1000;
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          period: Duration(milliseconds: timer),
          child: pollPostCard(),
        ),
      ],
    );
  }

  Widget pollPostCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            headerLoading(),
            contentLoading(),
            footerLoading(),
          ],
        ),
      ),
    );
  }

  Widget headerLoading() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
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
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 150,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentLoading() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), color: Colors.grey),
          ),

          const SizedBox(height: 25.0),
          // Options
          Container(
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.grey)),
          const SizedBox(height: 8.0),

          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
          const SizedBox(height: 8.0),

          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
          const SizedBox(height: 8.0),

          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget footerLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),
        const Divider(),
        Container(
          width: 90,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.grey),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => commentBuilder(),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: 3),
        const Divider(),
        Container(
          width: 90,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.grey),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => commentBuilder(),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: 3),
      ],
    );
  }

  Widget commentBuilder() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
