import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/loadings/image_with_name_skelton_loading.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/models/general_user_info.dart';

class FollowingsScreen extends StatelessWidget {
  final String id;
  const FollowingsScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GeneralUserInfoModel> followings = [];
    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppBloc bloc = AppBloc.get(context);
          followings = [];

          if (id == userId) {
            followings = bloc.currentUserFollowingList;
          } else {
            followings = bloc.followingList;
          }

          print(followings);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Following"),
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
                  condition: state is! GetFollowersOfPersonLoadingState,
                  builder: (context) {
                    return ConditionalBuilder(
                      condition: followings.isNotEmpty,
                      builder: (context) {
                        return ListView.builder(
                            itemCount: followings.length,
                            itemBuilder: (context, index) {
                              return followingBuilder(
                                context,
                                bloc,
                                following: followings[index],
                              );
                            });
                      },
                      fallback: (context) => const Center(
                        child: Text(
                          "Not found any following!",
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

  Widget followingBuilder(context, cubit, {GeneralUserInfoModel? following}) {
    return Container(
      child: profileImageWithUsernameComponent(
        context,
        cubit,
        following!.uId,
        following.isFollow,
        profileImage: following.image,
        fullName: following.fullName,
      ),
    );
  }
}
