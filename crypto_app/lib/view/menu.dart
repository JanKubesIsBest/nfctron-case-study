import 'package:crypto_app/model/List.dart';
import 'package:crypto_app/model/database/open_database.dart';
import 'package:crypto_app/model/database/retrieve.dart';
import 'package:crypto_app/view/pages/page.dart';
import 'package:crypto_app/view/row/rowForLists.dart';
import 'package:crypto_app/view/search_query/searchQuery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchedCrypto = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              pinned: true,
              floating: true,
              snap: false,
              elevation: 5,
              title: Text(widget.title),
              bottom: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration()
                            .applyDefaults(Theme.of(context).inputDecorationTheme)
                            .copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              hintText: 'Search cryptos...',
                              isCollapsed: true,
                            ),
                        onChanged: (value) {
                          setState(() {
                            // I won't make it with value notifier, as there is more logic to the notifier than just text.
                            searchedCrypto = value;
                          });
                        },
                      ),
                    ),
                    IconButton(onPressed: () {
                      setState(() {
                        searchedCrypto = "";
                        controller.clear();
                      });
                      // Unfocusing the keyboard
                      FocusManager.instance.primaryFocus?.unfocus();
                    }, icon: const Icon(Icons.clear))
                  ],
                ),
              ),
            )
          ];
        },
        body: searchedCrypto.isNotEmpty
            ? SearchQuery(
                searchedCrypto: searchedCrypto,
              )
            :
            // I'm doing it like this as there is a issue with performance of animation. 
            // I have found that you need to use Provider to fix performance. 
            ChangeNotifierProvider(
                create: (context) => CurrentPageProvider(),
                child: const PageViewBuilderForList(),
              ),
      ),
    );
  }
}

class PageViewBuilderForList extends StatefulWidget {
  const PageViewBuilderForList({super.key});

  @override
  State<StatefulWidget> createState() => _PageViewBuilderForListState();
}

class _PageViewBuilderForListState extends State<PageViewBuilderForList> {
  late Future<List<MyList>> lists;

  // Declare and initizlize the page controller
  final PageController _pageController = PageController(initialPage: 0);

  Future<List<MyList>> getListsWithDb() async {
    final Database db = await openMyDatabase();

    return await getLists(db, false);
  }

  @override
  void initState() {
    super.initState();
    lists = getListsWithDb();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MyList>>(
      future: lists,
      builder: (BuildContext context, AsyncSnapshot<List<MyList>> snapshot) {
        if (snapshot.hasData) {
            return Column(
              children: [
                RowForLists(
                  lists: snapshot.data!,
                  controller: _pageController,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    // Trending is included in the list as the first one
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MyPage(
                        // Trending id is 1
                        index: index + 1,
                        updateUI: updateLists,
                      );
                    },
                    // IDK if this is good way to this.
                    onPageChanged: (newValue) {
                      Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage(newValue);
                    },
                  ),
                ),
              ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void updateLists() {
    setState(() {
      lists = getListsWithDb();
    });
  }
}

class CurrentPageProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setCurrentPage(int newPage) {
    _currentPage = newPage;
    notifyListeners();
  }
}
