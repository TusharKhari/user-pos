class ProductModel {
  int? tableNo;
  List<String>? photos;
  int? status;
  int? quantity;
  String? category;
  String? description;
  List<NamePriceIsAdded>? extras;
  String? name;
  List<NamePriceIsAdded>? price;

  
  ProductModel({
    this.tableNo,
    this.photos,
    this.status,
    this.quantity,
    this.category,
    this.description,
    this.extras,
    this.name,
    this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parse photos list
    List<String>? photos;
    if (json['photos'] != null) {
      photos = [];
      json['photos'].forEach((photo) {
        photos!.add(photo);
      });
    }

    // Parse extras list
    List<NamePriceIsAdded>? extras;
    if (json['extras'] != null) {
      extras = [];
      json['extras'].forEach((extra) {
        extras!.add(NamePriceIsAdded.fromJson(extra));
      });
    }

    // Parse price list
    List<NamePriceIsAdded>? price;
    if (json['price'] != null) {
      price = [];
      json['price'].forEach((size) {
        price!.add(NamePriceIsAdded.fromJson(size));
      });
    }

    return ProductModel(
      tableNo: json['tableNo'],
      photos: photos,
      status: json['status'],
      quantity: json['quantity'],
      category: json['category'],
      description: json['description'],
      extras: extras,
      name: json['name'],
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tableNo'] = tableNo;
    data['photos'] = photos;
    data['status'] = status;
    data['quantity'] = quantity;
    data['category'] = category;
    data['description'] = description;
    if (extras != null) {
      data['extras'] = extras!.map((extra) => extra.toJson()).toList();
    }
    data['name'] = name;
    if (price != null) {
      data['price'] = price!.map((size) => size.toJson()).toList();
    }
    return data;
  }

  ProductModel copyWith({
    int? tableNo,
    List<String>? photos,
    int? status,
    int? quantity,
    String? category,
    String? description,
    List<NamePriceIsAdded>? extras,
    String? name,
    List<NamePriceIsAdded>? price,
  }) {
    return ProductModel(
      tableNo: tableNo ?? this.tableNo,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      description: description ?? this.description,
      extras: extras ?? this.extras,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}

class NamePriceIsAdded {
  String? name;
  String? price;
  bool? isAdded;

  NamePriceIsAdded({this.name, this.price, this.isAdded});

  factory NamePriceIsAdded.fromJson(Map<String, dynamic> json) {
    return NamePriceIsAdded(
      name: json['name'],
      price: json['price'].toString(),
      isAdded: json['isAdded'],
    );
  }

  NamePriceIsAdded copyWith({
    String? name,
    String? price,
    bool? isAdded,
  }) {
    return NamePriceIsAdded(
      name: name ?? this.name,
      price: price ?? this.price,
      isAdded: isAdded ?? this.isAdded,
    );
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['isAdded'] = isAdded;
    return data;
  }
}
