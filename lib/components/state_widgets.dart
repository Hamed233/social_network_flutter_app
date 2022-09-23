import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:savior/components/constants/constants.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: LottieBuilder.asset(Resources.appLoading,
            height: MediaQuery.of(context).size.height * 0.2),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: LottieBuilder.asset(Resources.empty,
            height: MediaQuery.of(context).size.height * 0.3),
      ),
    );
  }
}

class FailureWidget extends StatelessWidget {

  final String message;

  const FailureWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(message);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(Resources.error,
                  height: MediaQuery.of(context).size.height * 0.12),
              SizedBox(height: 20),
              Text(message, style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {

  final String searchIn;
  const SearchWidget({Key? key, required this.searchIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Resources.emptySearch,
                height: MediaQuery.of(context).size.height * 0.2),
            const SizedBox(height: 20),
            Text("Search ${searchIn} Here", style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}




class EmptyBoxWidget extends StatelessWidget {

  const EmptyBoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Resources.emptyBox,
                height: 100),
            const SizedBox(height: 20),
            Text("Sorry, Not found any decisions. add now!", style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey
            )),
          ],
        ),
      ),
    );
  }
}


class NotesEmptyWidget extends StatelessWidget {

  const NotesEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Resources.notes,
                height: 100),
            const SizedBox(height: 20),
            Text("Not found any notes. add now!", style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey
            )),
          ],
        ),
      ),
    );
  }
}