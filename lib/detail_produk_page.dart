import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailProdukPage extends StatefulWidget {
  final int productId;

  const DetailProdukPage({super.key, required this.productId});

  @override
  _DetailProdukPageState createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  Map<String, dynamic> product = {};
  List<dynamic> reviews = [];
  int cartQuantity = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  //function for fetch product data from api
  Future<void> fetchProductDetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.194.233:3005/product/${widget.productId}?format=json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data']['product'] != null) {
          setState(() {
            product = data['data']['product']['data'] ?? {};
            reviews = data['data']['reviews'] ?? [];

            isLoading = false;
          });
        } else {
          throw Exception("Unexpected response format: $data");
        }
      } else {
        throw Exception(
            "Failed to load product detail. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching product detail: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : product.isEmpty
              ? const Center(
                  child: Text("Product Not Found"),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: product['image_url'] != null
                                    ? NetworkImage(product['image_url'])
                                    : const AssetImage('assets/product.jpg')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                product['name'] ?? 'Product Not Available',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 3.0,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp',
                                  decimalDigits: 2,
                                ).format(product['price'] ?? 0),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 3.0,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product['description'] ?? 'Description Not Available',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Button Add to Cart
                      ElevatedButton(
                        onPressed: () {
                          log("Add to Cart");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 12.0),
                        ),
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Review product
                      if (reviews.isNotEmpty) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Reviews: ",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ...reviews.map((review) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['review']['comment'] ?? 'No comment',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < (review['review']['ratings'] ?? 0)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20.0,
                                  );
                                }),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          );
                        }),
                      ] else
                        const Text(
                          'There are no reviews yet.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                    ],
                  ),
                ),
    );
  }
}
