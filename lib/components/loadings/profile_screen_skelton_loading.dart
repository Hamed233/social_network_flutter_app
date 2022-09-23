import 'package:flutter/material.dart';
import 'package:savior/components/loadings/poll_post_skelton_loading.dart';
import 'package:savior/components/numbers_widget.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenSkeletonLoading extends StatefulWidget {
  const ProfileScreenSkeletonLoading({Key? key}) : super(key: key);

  @override
  _ProfileScreenSkeletonLoadingState createState() =>
      _ProfileScreenSkeletonLoadingState();
}

class _ProfileScreenSkeletonLoadingState
    extends State<ProfileScreenSkeletonLoading> {
  @override
  Widget build(BuildContext context) {
    int timer = 1000;
    return ListView(children: [
      Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.white,
        period: Duration(milliseconds: timer),
        child: _buildHeader(),
      ),
      // PollPostSkeletonLoading(),
     
    ]);
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: <Widget>[
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsetsDirectional.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    height: 30,
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 135, // (background container size) - (circle height / 2)
          child: Container(
            clipBehavior: Clip.none,
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 8,
              ),
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget box() {
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
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            width: 60,
            height: 30,
            decoration:
                BoxDecoration(shape: BoxShape.rectangle, color: Colors.grey),
          ),
        ],
      ),
    );
  }

}
