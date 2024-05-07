// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lamie/view/pages/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/controller/tokens/token_manager.dart';
import 'package:lamie/providers/chatlist_provider.dart';
import 'package:lamie/providers/togle_searchbar.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/pages/auth_page/auth_page.dart';
import 'package:lamie/view/pages/home/widgets/chat_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatListProvider>(context, listen: false).fetchUserChats();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ProjectColors.blackColor,
      drawer: MyDrawer(homeCtx: context),
      body: const MyHideableAppBar(),
    );
  }
}

class MyHideableAppBar extends StatefulWidget {
  const MyHideableAppBar({super.key});

  @override
  State<MyHideableAppBar> createState() => _MyHideableAppBarState();
}

class _MyHideableAppBarState extends State<MyHideableAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ToggleSearchBarProvider>(
        builder: (context, toggleProvider, child) => CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: ProjectColors.blackColor,
                  automaticallyImplyLeading: false,
                  title: toggleProvider.showSearch
                      ? CupertinoTextField(
                          controller: _searchController,
                          placeholder: 'Search...',
                          style: TextStyle(color: ProjectColors.blackColor),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: ProjectColors.whiteColor,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              Provider.of<ChatListProvider>(context,
                                      listen: false)
                                  .fetchUserChats();
                            } else {
                              Provider.of<ChatListProvider>(context,
                                      listen: false)
                                  .searchUserChats(value);
                            }
                          },
                        )
                      : CustomText.createCustomText(
                          context: context,
                          text: 'Real Chat',
                          textType: TextType.heading,
                          color: ProjectColors.whiteColor),
                  floating: true,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        if (toggleProvider.showSearch) {
                          _searchController.clear();
                          Provider.of<ChatListProvider>(context, listen: false)
                              .fetchUserChats();
                        }
                        toggleProvider.toggleSearchBar();
                      },
                      icon: Icon(
                          toggleProvider.showSearch
                              ? Icons.close
                              : Icons.search_sharp,
                          size: 27),
                      color: ProjectColors.whiteColor,
                    ),
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.more_vert_rounded, size: 27),
                      color: ProjectColors.whiteColor,
                    ),
                  ],
                ),
                Consumer<ChatListProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (provider.errorMessage != null) {
                      return SliverFillRemaining(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(provider.errorMessage!),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AuthPage(),
                                      ),
                                      (route) => false);
                                },
                                child: Text(
                                    '${provider.errorMessage} Click To Login'))
                          ],
                        )),
                      );
                    }
                    if (provider.user == null) {
                      provider.fetchUserChats();
                      return const SliverFillRemaining(
                        child: Center(child: Text("Loading...")),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final connection = provider.user?.connections[index];

                          return Padding(
                            padding: EdgeInsets.all(
                                ScreenSize.getHeight(context) / 100),
                            child: CustomChatTile(
                              senderId: provider.user!.id,
                              receiverId: connection?.id,
                              height: ScreenSize.getHeight(context),
                              width: ScreenSize.getWidth(context),
                              userName: connection?.username ?? 'Unknown',
                              receiverEmail: connection?.email ?? '',
                              senderEmail: provider.user?.email ?? "",
                            ),
                          );
                        },
                        childCount: provider.user?.connections.length ?? 0,
                      ),
                    );
                  },
                ),
              ],
            ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

//////
class MyDrawer extends StatelessWidget {
  final BuildContext homeCtx;
  const MyDrawer({
    Key? key,
    required this.homeCtx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = ScreenSize.getWidth(context);
    return Drawer(
      child: Consumer<ChatListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return DrawerHeader(
                decoration: BoxDecoration(color: ProjectColors.liteGrey),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AuthPage(),
                                  ),
                                  (route) => false);
                            },
                            child:
                                Text('${provider.errorMessage} Click To Login'))
                      ]),
                ));
          }
          if (provider.user == null) {
            provider.fetchUserChats();
            return const Center(child: Text("Loading..."));
          }
          final user = provider.user;
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: ProjectColors.blueColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: w / 8,
                          backgroundColor: ProjectColors.blackColor,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                user!.username[0],
                                style: TextStyle(
                                  color: ProjectColors.whiteColor,
                                  fontSize: w / 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        CustomText.createCustomText(
                            context: context,
                            text: user.username,
                            textType: TextType.subheading,
                            color: ProjectColors.whiteColor),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText.createCustomText(
                    context: context,
                    text: user.email,
                    textType: TextType.normal,
                    color: ProjectColors.blackColor),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout),
                  title: CustomText.createCustomText(
                      context: context,
                      text: "LogOut",
                      textType: TextType.normal,
                      color: ProjectColors.blackColor),
                  onTap: () async {
                    showLogoutConfirmation(homeCtx);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

///

void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              await TokenManager.deleteAllTokens();
              Provider.of<ChatListProvider>(context, listen: false).clearData();
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                  (route) => false);
            },
          ),
        ],
      );
    },
  );
}
