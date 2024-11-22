import 'package:fenix_app_v2/features/home/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/home/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _MenuView(),
    );
  }
}

class _MenuView extends ConsumerStatefulWidget {
  const _MenuView();

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // scrollController.addListener(() {
    //   if ((scrollController.position.pixels + 400) >=
    //       scrollController.position.maxScrollExtent) {
    //     ref.read(menuProvider.notifier).loadNextPage();
    //   }
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: menuState.menus.length,
        itemBuilder: (context, index) {
          final menu = menuState.menus[index];
          return GestureDetector(
              // onTap: () => context.push('/product/${menu.idMenu}'),
              child: MenuCard(menu: menu));
        },
      ),
    );
  }
}
