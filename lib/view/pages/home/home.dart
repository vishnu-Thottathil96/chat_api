import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(
      //         Icons.search_sharp,
      //         size: 27,
      //       ),
      //       color: ProjectColors.primaryViolet,
      //     ),
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(
      //         Icons.more_vert_rounded,
      //         size: 27,
      //       ),
      //       color: ProjectColors.primaryViolet,
      //     ),
      //   ],
      //   automaticallyImplyLeading: false,
      //   title: CustomText.createCustomText(
      //       context: context,
      //       text: 'Fiber',
      //       textType: TextType.heading,
      //       color: ProjectColors.primaryViolet),
      // ),
      body: MyHideableAppBar(
        context: context,
      ),
    );
  }
}

class MyHideableAppBar extends StatelessWidget {
  final BuildContext context;

  const MyHideableAppBar({super.key, required this.context});

  @override
  Widget build(context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          title: CustomText.createCustomText(
              context: context,
              text: 'Fiber',
              textType: TextType.heading,
              color: ProjectColors.primaryViolet),
          floating: true, // This makes the app bar hide and show
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_sharp,
                size: 27,
              ),
              color: ProjectColors.primaryViolet,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                size: 27,
              ),
              color: ProjectColors.primaryViolet,
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: Text('Item #$index')),
            childCount: 100, // Number of list items
          ),
        ),
      ],
    );
  }
}
