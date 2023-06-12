import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String magentoHost = 'www.broadwaylifestyle.com';
const String magentoLogo = 'https://www.broadwaylifestyle.com/media/logo/websites/1/logo.png';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProductApi productApi = ProductApi();
  final ScrollController _scrollController = ScrollController();
  final List<Product> _products = [];
  int _currentPage = 1;

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 1000) {
      productApi.fetch(_currentPage++);
    }
  }

  @override
  void initState() {
    super.initState();
    productApi.productStream.listen((List<Product> newProducts) {
      setState(() {
        _products.addAll(newProducts);
      });
    });
    _scrollController.addListener(_onScroll);
    productApi.fetch(_currentPage++);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    productApi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
          controller: _scrollController,
          
          slivers: <Widget>[
             SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 160,
              flexibleSpace:  FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Image.network(magentoLogo),
                ),
                background:   Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [ Colors.white,Colors.white, ]))),
              ),
            ),
            SliverGrid( 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 0.6,
              ),
              delegate: SliverChildBuilderDelegate( (context,index) {
                debugPrint('SliverChildBuilderDelegate ()');
                if (index >= _products.length) {
                  return null;
                }
                var item = _products[index];
                return Column(
                  
                  children: [
                    Image.network(item.imageUrl.toString(), height: 184.0, width: 184.0, fit: BoxFit.fitHeight),
                    SizedBox(width: 184, child: Text(item.name)),
                    Expanded(child: Container()),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        foregroundColor: Colors.grey,
                        side: const BorderSide(
                          color: Colors.grey
                          )  
                      ),
                      onPressed: (){}, icon: const Icon(Icons.shopping_cart), label: const Text('加入購物車'),
                      )
                  ],
                );
              }, childCount: _products.length ),
            
            )
          ],
        ),
    );
  }
}



// api
class Product {
  String name;
  Uri imageUrl;
  int id;
  Product(this.id, this.name, this.imageUrl);
}

class ProductApi {
  Future<List<Product>> _fetchProducts({int page =0}) async {
    try {
      debugPrint('fetchProducts: page = $page');
      var url = Uri(
        scheme: 'https', 
        host: magentoHost, 
        path: '/rest/V1/products-render-info', queryParameters: { 
          'searchCriteria[sortOrders][0][field]': 'entity_id',
          'searchCriteria[sortOrders][0][direction]':'DESC',
          'searchCriteria[pageSize]': '20', 
          'searchCriteria[currentPage]': '$page', 
          'storeId' :'0', 
          'currencyCode': 'hkd' 
        });

      var resp = await http.get(url);
      var map = jsonDecode( resp.body );

      var ret = <Product>[];
      for(var item in map['items']) {
        //print('name: ${item['name']}');
        var image = item['images'].first;
        //print(' url: ${image['url']}');
        ret.add(Product(item['id'] ,item['name'], Uri.parse( image['url'] )));
      }
      return ret;
    }
    catch(e) {
      return List<Product>.empty();
    }  
  }


  final StreamController<List<Product>> _streamController = StreamController<List<Product>>();
  bool _isProcessing = false;

  void fetch(int page) async {  
    if(!_streamController.isClosed && ! _isProcessing) {
      _isProcessing = true;
      List<Product> products = await _fetchProducts( page: page);
      _streamController.add(products);
      _isProcessing = false;
    }
  }

  void dispose() {
    _streamController.close();
    _isProcessing = false;
  }

  Stream<List<Product>> get productStream => _streamController.stream;
}