import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/numbers_widget.dart';
import 'package:savior/components/styles/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  List<Tab> tabs = <Tab>[
    Tab(
      icon: Row(
        children: [
          Icon(
            FontAwesomeIcons.house,
            color: AppColors.appMainColors,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'home'.toUpperCase(),
            // style: TextStyle(
            //   fontSize: 16,
            //   color: Color.fromARGB(255, 12, 11, 11),
            // ),
          ),
        ],
      ),
    ),
    Tab(
      icon: Row(
        children: [
          Icon(
            Icons.poll_outlined,
            color: AppColors.appMainColors,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'decisions'.toUpperCase(),
            // style: TextStyle(
            //   fontSize: 16,
            //   color: Color.fromARGB(255, 12, 11, 11),
            // ),
          ),
        ],
      ),
    ),
    Tab(
      icon: Row(
        children: [
          Icon(
            FontAwesomeIcons.puzzlePiece,
            color: AppColors.appMainColors,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'problems'.toUpperCase(),
            // style: TextStyle(
            //   fontSize: 16,
            //   color: Color.fromARGB(255, 12, 11, 11),
            // ),
          ),
        ],
      ),
    ),
    Tab(
      icon: Row(
        children: [
          Icon(
            FontAwesomeIcons.thumbsUp,
            color: AppColors.appMainColors,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'polls reactions'.toUpperCase(),
            // style: TextStyle(
            //   fontSize: 16,
            //   color: Color.fromARGB(255, 12, 11, 11),
            // ),
          ),
        ],
      ),
    ),
    Tab(
      icon: Row(
        children: [
          Icon(
            FontAwesomeIcons.thumbsUp,
            color: AppColors.appMainColors,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'problems reactions'.toUpperCase(),
            // style: TextStyle(
            //   fontSize: 16,
            //   color: Color.fromARGB(255, 12, 11, 11),
            // ),
          ),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profileImage;
    var coverImage;
    var username;
    var jobTitle;
    var bio = "No bio";
    var problemsLength = 0;
    var pollsLength = 0;
    var followersLength = 0;
    var followingLength = 0;

    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppBloc cubit = AppBloc.get(context);
          if (cubit.userModel != null) {
            profileImage =
                cubit.userModel!.image!.isEmpty ? '' : cubit.userModel!.image;
            coverImage = cubit.userModel!.cover!.isEmpty
                ? "https://images.unsplash.com/photo-1498721409281-998093cc905b?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjY2fHxiYWNrZ3JvdW5kJTIwY292ZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=600"
                : cubit.userModel!.cover;
            username = cubit.userModel!.fullName;
            jobTitle = cubit.userModel!.jobTitle;
            bio = cubit.userModel!.bio!;
          }

          problemsLength = cubit.personProblemsList.length;
          pollsLength = cubit.personPollsList.length;
          followersLength = cubit.currentUserFollowersList.length;
          followingLength = cubit.currentUserFollowingList.length;
          
          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                    child: _buildHeader(
                        profileImage,
                        coverImage,
                        username,
                        jobTitle,
                        bio,
                        problemsLength,
                        pollsLength,
                        followersLength,
                        followingLength)),
                SliverToBoxAdapter(
                  child: TabBar(
                    isScrollable: true,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    automaticIndicatorColorAdjustment: true,
                    indicatorColor: AppColors.appMainColors,
                    labelColor: AppColors.appMainColors,
                    controller: _tabController,
                    tabs: tabs,
                    physics: const BouncingScrollPhysics(),
                    onTap: (int? index) =>
                        AppBloc.get(context).changeTabNav(index!),
                  ),
                ),
              ];
            },
            body: Container(
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children:
                    AppBloc.get(context).tabScreens.map((Widget currentTab) {
                  return currentTab;
                }).toList(),
              ),
            ),
          );
        });
  }

  Widget socialMediaWidget() {
    return Container(
        padding: EdgeInsetsDirectional.all(5),
        decoration: BoxDecoration(
          color: Color.fromARGB(53, 0, 0, 0),
          borderRadius:
              BorderRadiusDirectional.only(topEnd: Radius.circular(10)),
        ),
        child: Row(
          children: [
            InkWell(
              child: Icon(Icons.facebook, size: 26),
              onTap: () {
                print("test");
              },
            ),
            SizedBox(
              width: 9,
            ),
            InkWell(
              child: Icon(
                Icons.whatsapp,
                size: 26,
              ),
              onTap: () {
                print("test");
              },
            ),
            SizedBox(
              width: 9,
            ),
            InkWell(
              child: Icon(Icons.telegram, size: 26),
              onTap: () {
                print("test");
              },
            ),
          ],
        ));
  }

  Widget _buildHeader(
      String profileImage,
      String coverImage,
      String username,
      String jobTitle,
      String bio,
      int problemsLength,
      int pollsLength,
      int followersLength,
      int followingLength) {
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
                  color: Colors.transparent,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(coverImage)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: socialMediaWidget(),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsetsDirectional.only(top: 60),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            height: 1.3),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.check_circle,
                        color: AppColors.appMainColors,
                        size: 16.0,
                      )
                    ],
                  ),
                  if (jobTitle != '') const SizedBox(height: 10),
                  if (jobTitle != '')
                    Text(
                      jobTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (bio != '') const SizedBox(height: 20),
                  if (bio != '')
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 25, end: 25, top: 10),
                      child: Text(
                        bio,
                        style: TextStyle(color: Colors.grey),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 24),
                  NumbersWidget(
                      problemsLength: problemsLength,
                      pollsLength: pollsLength,
                      followersLength: followersLength,
                      followingLength: followingLength,
                      usrId: userId),
                  const SizedBox(height: 20),
                
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 150, // (background container size) - (circle height / 2)
          child: Container(
            clipBehavior: Clip.none,
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              shape: BoxShape.circle,
              color: Colors.transparent,
              image: profileImage.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(profileImage),
                    )
                  : null,
            ),
            child: profileImage.isEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(
                      username[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
