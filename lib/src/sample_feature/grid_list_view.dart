import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_signin/src/model/product.dart';
import 'package:flutter_signin/src/model/products_repository.dart';

import '../settings/settings_view.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class GridItemListView extends StatelessWidget {
  const GridItemListView({
    super.key,
  });

  static const routeName = '/grid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            semanticLabel: 'menu',),
            onPressed: () {
              print('Menu button');
            },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset('flutter_logo.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children :[
            headerTopCategories(),
            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              shrinkWrap: true,
              // TODO: Build a grid of cards (102)
              children: _buildGridCards(context),
            ),
          ]
        ),
      )
    );
  }
}

Widget headerTopCategories() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // sectionHeader('All Categories', onViewMore: () {}),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem(Category.clothing.name, Icons.food_bank, onPressed: () {}),
              headerCategoryItem(Category.accessories.name, Icons.food_bank, onPressed: () {}),
              headerCategoryItem(Category.home.name, Icons.food_bank, onPressed: () {}),
              headerCategoryItem(Category.shoes.name, Icons.food_bank, onPressed: () {}),
              headerCategoryItem(Category.sports.name, Icons.food_bank, onPressed: () {}),
              headerCategoryItem(Category.bags.name, Icons.food_bank, onPressed: () {}),
              headerCategoryItem(Category.beauty.name, Icons.food_bank, onPressed: () {}),
            ],
          ),
        )
      ],
    ),
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )),
        Text(name + ' ›')
      ],
    ),
  );
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle),
      ),
      Container(
        margin: EdgeInsets.only(left: 15, top: 2),
        child: TextButton(
          onPressed: onViewMore,
          child: Text('View all ›'),
        ),
      )
    ],
  );
}

List<Card> _buildGridCards(BuildContext context) {
  List<Product> products = ProductsRepository.loadProducts(Category.all);

  if (products.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);
  final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString());

  return products.map((product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // TODO: Adjust card heights (103)
      child: InkWell(
        onTap: () => Navigator.pushNamed(
                context,
                SampleItemDetailsView.routeName,
                arguments: product
              ),
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
               // TODO: Adjust the box size (102)
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                 // TODO: Align labels to the bottom and center (103)
                 crossAxisAlignment: CrossAxisAlignment.start,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[
                   // TODO: Handle overflowing labels (103)
                   Text(
                      product.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();
}