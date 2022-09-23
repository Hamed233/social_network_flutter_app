import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savior/blocs/general_app_bloc/app_general_bloc.dart';
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/numbers_widget.dart';
import 'package:savior/components/loadings/profile_screen_skelton_loading.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/components/styles/colors.dart';
import 'package:savior/models/user.dart';

class PersonProfileScreen extends StatefulWidget {
  final String usrId;
  PersonProfileScreen({Key? key, required this.usrId}) : super(key: key);

  @override
  State<PersonProfileScreen> createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen>
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
    var profileImage = 'color';
    var coverImage =
        "https://images.unsplash.com/photo-1498721409281-998093cc905b?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjY2fHxiYWNrZ3JvdW5kJTIwY292ZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=600";
    var username = '';
    var jobTitle = '';
    var bio = "No bio";
    var problemsLength = 0;
    var pollsLength = 0;
    var followersLength = 0;
    var followingLength = 0;

    AppBloc cubit = AppBloc.get(context);

    if (widget.usrId.isNotEmpty) {
      // Get Data
      cubit.getPersonProfileData(id: widget.usrId);
      cubit.getFollowersOfPerson(id: widget.usrId);
      cubit.getFollowingOfPerson(id: widget.usrId);
    }

    return BlocConsumer<AppBloc, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserModel profileModel = cubit.personProfileModel;

          if (profileModel.uId != null) {
            profileImage =
                profileModel.image! != '' ? profileModel.image! : profileImage;
            coverImage =
                profileModel.cover! != '' ? profileModel.cover! : coverImage;
            username = profileModel.fullName!;
            jobTitle = profileModel.jobTitle!;
            bio = profileModel.bio!;
          }

          problemsLength = cubit.personProblemsList.length;
          pollsLength = cubit.personPollsList.length;
          followersLength = cubit.followersList.length;
          followingLength = cubit.followingList.length;
          print(followersLength);

          return Scaffold(
            body: state is! GetPersonProfileDataLoadingState ||
                    state is! GetFollowersOfPersonLoadingState ||
                    state is! GetFollowingOfPersonLoadingState ||
                    state is! GetAllPollsDataForPersonLoadingState ||
                    state is! GetCurrentInfoAboutUserLoadingState ||
                    state is! GetCurrentProblemsReactionsAboutUserLoadingState ||
                    state is! GetAllProblemsForPersonDataLoadingState 
                    
                ? NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverToBoxAdapter(
                            child: _buildHeader(
                                cubit,
                                profileModel,
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
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
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
                          children: AppBloc.get(context)
                              .tabScreens
                              .map((Widget currentTab) {
                            return currentTab;
                          }).toList(),
                        )),
                  )
                : const ProfileScreenSkeletonLoading(),
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
    AppBloc cubit,
    UserModel profileModel,
    String profileImage,
    String coverImage,
    String username,
    String jobTitle,
    String bio,
    int problemsLength,
    int pollsLength,
    int followersLength,
    int followingLength,
  ) {
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
                        style: const TextStyle(
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
                  const SizedBox(height: 10),
                  if (jobTitle != '')
                    Text(
                      jobTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (jobTitle != '') const SizedBox(height: 20),
                  if (widget.usrId != userId)
                    btnBuilder(
                      context, cubit, cubit.currentVisitedProfileData.isFollow,
                      usrId: widget.usrId,
                      fullName: profileModel.fullName,
                      image: profileModel.image,
                      jobTitle: profileModel.jobTitle,
                      // width: MediaQuery.of(context).size.width * 0.3,
                      followId: cubit.currentVisitedProfileData.id,
                      followingDocId:
                          cubit.currentVisitedProfileData.followingDocId,
                    ),

                  if (bio != '') const SizedBox(height: 15),
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
                      usrId: widget.usrId),
                  const SizedBox(height: 20),
                  // const Divider(),
                  // Container(
                  //   height: 50,
                  //   width: double.infinity,
                  //   color: Color.fromARGB(255, 251, 251, 251),
                  //   child: TabBar(
                  //     isScrollable: true,
                  //     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  //     automaticIndicatorColorAdjustment: true,
                  //     indicatorColor: AppColors.appMainColors,
                  //     labelColor: AppColors.appMainColors,
                  //     controller: _tabController,
                  //     tabs: tabs,
                  //     physics: const BouncingScrollPhysics(),
                  //     onTap: (int? index) =>
                  //         AppBloc.get(context).changeTabNav(index!),
                  //   ),
                  // ),
                  // Column(
                  //   // mainAxisSize: MainAxisSize.min,
                  //   // crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: [
                  //     TabBarView(
                  //       controller: _tabController,
                  //       children: AppBloc.get(context)
                  //           .tabScreens
                  //           .map((Widget currentTab) {
                  //         return currentTab;
                  //       }).toList(),
                  //     ),
                  //   ],
                  // ),
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
              image: profileImage != "color"
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(profileImage),
                    )
                  : null,
            ),
            child: profileImage == "color"
                ? CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: username.isNotEmpty
                        ? Text(
                            username[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                          )
                        : null,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
