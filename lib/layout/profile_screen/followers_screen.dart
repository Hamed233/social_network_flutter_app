import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/loadings/image_with_name_skelton_loading.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/models/general_user_info.dart';

class FollowersScren extends StatelessWidget {
  final String id;
  const FollowersScren({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GeneralUserInfoModel> followers = [];

    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppBloc bloc = AppBloc.get(context);
          followers = [];
          if (id == userId) {
            if (bloc.currentUserFollowersList.isNotEmpty) {
              followers = bloc.currentUserFollowersList;
            }
          } else {
            if (bloc.followersList.isNotEmpty) {
              followers = bloc.followersList;
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Followers"),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: .2,
            ),
            body: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConditionalBuilder(
                  condition: state is! GetFollowersOfPersonLoadingState ||
                      state is! GetFollowersOfCurrentUserLoadingState,
                  builder: (context) {
                    return ConditionalBuilder(
                      condition: followers.isNotEmpty,
                      builder: (context) {
                        return ListView.builder(
                            itemCount: followers.length,
                            itemBuilder: (context, index) {
                              return followerBuilder(
                                context,
                                bloc,
                                follower: followers[index],
                              );
                            });
                      },
                      fallback: (context) => const Center(
                        child: Text(
                          "Not found any followers!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                  fallback: (context) => const ImageWithNameSkeletonLoading(),
                ),
              ),
            ),
          );
        });
  }

  Widget followerBuilder(context, bloc, {follower}) {
    return Container(
      child: profileImageWithUsernameComponent(
        context,
        bloc,
        follower!.uId,
        follower.isFollow,
        profileImage: follower!.image,
        fullName: follower!.fullName,
      ),
    );
  }
}
